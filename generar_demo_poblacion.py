"""
Genera demo_poblacion.sql: pacientes y atenciones FICTICIOS de todo el país para la demostración
(mapa de vigilancia lleno, recetas, farmacia, crecimiento infantil y vacunación).

Los datos son inventados pero coherentes:
  - cada diagnóstico (CIE-10 del catálogo de Salud) encaja con la edad y el sexo del paciente;
  - las dosis de niños se calculan por peso (mg/kg) y se redondean a 0.5 ml; las de adultos son
    las de adulto; no se recetan AINE a hipertensos ni en dengue; se respetan las alergias
    (penicilina -> azitromicina, AINE -> acetaminofén);
  - la geografía sigue a Guatemala: dengue, chikungunya y malaria en tierras bajas; desnutrición
    en el Corredor Seco y el occidente; apellidos mayas donde corresponde;
  - la talla y el peso de los niños salen de las curvas de la OMS (crecimiento.py del backend);
  - no aparecen alertas de brote salvo las dos que se planearon (dengue en Escuintla y diarreas
    en Cobán), revisado con la misma regla del backend para hoy y los 7 días siguientes.

Las fechas son relativas al día en que se carga el script (DATE_SUB(CURDATE(), ...)).
El resultado es siempre el mismo (semilla fija). Uso, desde SALUD-DATABASE:
    python generar_demo_poblacion.py        (necesita ../SALUD-BACKEND)
"""
import json
import math
import os
import random
import sys
from collections import Counter

AQUI = os.path.dirname(os.path.abspath(__file__))
BACKEND = os.path.join(AQUI, "..", "SALUD-BACKEND")
sys.path.insert(0, BACKEND)
import crecimiento  # noqa: E402  (curvas de la OMS)

R = random.Random(20261021)
SALIDA = os.path.join(AQUI, "demo_poblacion.sql")
HOY_DIAS = 0            # "días atrás" se cuenta desde el día de carga

with open(os.path.join(BACKEND, "datos", "municipios_gt.json"), encoding="utf-8") as f:
    GEO = json.load(f)
MUNICIPIOS = GEO["municipios"]          # {"0101": {"departamento", "nombre", "lat", "lon"}, ...}

# --------------------------------------------------------------------------- regiones
TIERRA_BAJA = {"05", "06", "10", "11", "17", "18", "19", "20", "21", "22", "02"}   # dengue/chikungunya
MALARIA = {"05", "16", "17", "18"}
CORREDOR_SECO = {"02", "19", "20", "21", "15", "22"}
OCCIDENTE = {"07", "08", "09", "12", "13", "14"}
MAYA_KICHE = {"03", "04", "07", "08", "09", "14"}
MAYA_QEQCHI = {"16", "17", "15"}
MAM = {"12", "13"}
# media de talla/edad (z) de los niños por región: la desnutrición crónica es mucho mayor en el occidente
# (aprox. a la ENSMI: cerca de la mitad de los niños con talla baja; 7 de cada 10 en Totonicapán)
Z_TALLA = {"08": -2.4, "07": -2.2, "14": -2.2, "13": -2.0, "16": -1.9, "12": -1.8, "15": -1.6, "04": -1.6,
           "09": -1.5, "21": -1.5, "20": -1.4, "19": -1.3, "02": -1.1, "22": -1.2, "03": -1.2, "17": -1.1,
           "18": -1.1, "05": -0.9, "06": -1.0, "10": -1.1, "11": -1.0, "01": -0.6}

EXCLUIR = {"0101", "0102", "0103", "0104", "0105", "0106", "0107", "0108", "0109", "0115", "2002"}  # ya tienen datos demo/pruebas
BROTES = {("0501", "arbovirosis"): (9, 2), ("1601", "diarreicas"): (8, 3)}   # (últimos 7 días, 4 semanas antes)

# --------------------------------------------------------------------------- nombres
H_MAYOR = ["José", "Juan", "Pedro", "Manuel", "Francisco", "Domingo", "Santos", "Marcos", "Sebastián", "Andrés",
           "Tomás", "Diego", "Miguel", "Antonio", "Carlos", "Luis", "Jorge", "Mario", "Julio", "Rigoberto", "Ernesto"]
M_MAYOR = ["María", "Juana", "Rosa", "Candelaria", "Catarina", "Magdalena", "Elena", "Lucía", "Petrona", "Dominga",
           "Marta", "Ana", "Carmen", "Josefa", "Isabel", "Olga", "Gloria", "Thelma", "Blanca", "Concepción"]
H_JOVEN = ["Brayan", "Kevin", "Jefferson", "Wilmer", "Erick", "Byron", "Edgar", "Ángel", "Josué", "Cristian",
           "Daniel", "Anderson", "Jonathan", "Alexander", "Diego", "Mynor", "Selvin", "Henry", "Dylan", "Mateo",
           "Santiago", "Emanuel", "Jairo", "Fernando"]
M_JOVEN = ["Dulce", "Ashley", "Yesenia", "Mayra", "Glendy", "Heidy", "Jennifer", "Katherine", "Dayana", "Génesis",
           "Allison", "Andrea", "Sofía", "Valeria", "Camila", "Daniela", "Fernanda", "Yoselin", "Estefany",
           "Mildred", "Sindy", "Ingrid", "Marisol", "Abigail"]
SEGUNDO_H = ["Antonio", "Alejandro", "Fernando", "José", "Manuel", "Roberto", "Eduardo", "Estuardo", "Rafael", "David"]
SEGUNDO_M = ["María", "Isabel", "Elizabeth", "Beatriz", "Fernanda", "Lucía", "Alejandra", "Guadalupe", "Esperanza", "Noemí"]
AP_ESP = ["Morales", "Cordón", "Lemus", "Guerra", "Portillo", "Aldana", "Sagastume", "Interiano", "Duarte", "Monroy",
          "Pineda", "Villeda", "Recinos", "Paiz", "Orellana", "Cardona", "Salguero", "Ruano", "Marroquín", "Sandoval",
          "Barrientos", "Estrada", "Hernández", "García", "López", "Pérez", "Ramírez", "Castillo", "Rodríguez",
          "Martínez", "Cruz", "Flores", "Ortiz", "Aguilar", "Méndez", "Reyes", "Mejía", "Vásquez", "Juárez", "Gómez"]
AP_KICHE = ["Tzoc", "Ixcoy", "Batz", "Chumil", "Tum", "Coyoy", "Pu", "Tzunun", "Cux", "Xicará", "Ajú", "Sicajau",
            "Chex", "Ixmatá", "Saquic", "Cumes", "Sincal", "Chicol", "Tziquín", "Xocop", "Yax", "Quiacaín", "Tuy"]
AP_QEQCHI = ["Caal", "Choc", "Tiul", "Coc", "Pop", "Xol", "Cuz", "Maquin", "Chub", "Bac", "Ical", "Cucul", "Tzi",
             "Che", "Chen", "Sacul", "Xuc", "Pacay"]
AP_MAM = ["Pérez", "Domingo", "Ramírez", "Jiménez", "Mendoza", "Gómez", "Ramos", "López", "Velásquez", "Bámaca",
          "Fuentes", "Cifuentes", "Tomás", "Escalante", "Ajanel", "Mazariegos"]
ZONAS_CAB = ["Zona 1", "Zona 2", "Zona 3", "Zona 4", "Barrio El Centro", "Barrio El Calvario", "Barrio San Sebastián",
             "Colonia Las Flores", "Colonia El Mirador"]
ZONAS = ["Aldea San José", "Aldea Santa Cruz", "Aldea El Rosario", "Aldea San Antonio", "Caserío Buena Vista",
         "Caserío La Esperanza", "Caserío Los Pinos", "Cantón Central", "Cabecera municipal", "Aldea Nueva Esperanza"]
MEDICOS = ["Mariela Castañeda", "Luis Fernando Ajú", "Carlos Ruiz", "Sandra Pacay", "Héctor Monzón",
           "Gabriela Interiano", "Óscar Tzunun", "Claudia Recinos"]


def apellidos(depto):
    if depto in MAYA_KICHE and R.random() < 0.6:
        pool = AP_KICHE
    elif depto in MAYA_QEQCHI and R.random() < 0.65:
        pool = AP_QEQCHI
    elif depto in MAM and R.random() < 0.7:
        pool = AP_MAM
    else:
        pool = AP_ESP
    return R.choice(pool), R.choice(pool if R.random() < 0.7 else AP_ESP)


def nombre(sexo, anio_nac, depto):
    joven = anio_nac >= 1988
    pool = (H_JOVEN if joven else H_MAYOR) if sexo == "M" else (M_JOVEN if joven else M_MAYOR)
    primero = R.choice(pool)
    segundo = R.choice(SEGUNDO_H if sexo == "M" else SEGUNDO_M)
    while segundo == primero:
        segundo = R.choice(SEGUNDO_H if sexo == "M" else SEGUNDO_M)
    a1, a2 = apellidos(depto)
    return f"{primero} {segundo} {a1} {a2}"


def telefono():
    return f"{R.choice('345')}{R.randint(0, 9999999):07d}"


# --------------------------------------------------------------------------- medicamentos nuevos
NUEVOS = [  # código, nombre, presentación, existencia, mínimo, precio
    ("MED-101", "Acetaminofén", "Suspensión 120 mg/5 ml, frasco 120 ml", 160, 40, 12.00),
    ("MED-102", "Ibuprofeno", "Suspensión 100 mg/5 ml, frasco 120 ml", 90, 30, 15.00),
    ("MED-103", "Zinc", "Tableta dispersable 20 mg", 600, 150, 0.35),
    ("MED-104", "Albendazol", "Tableta masticable 400 mg", 400, 100, 1.50),
    ("MED-105", "Albendazol", "Suspensión 200 mg/5 ml, frasco 10 ml", 60, 20, 8.00),
    ("MED-106", "Azitromicina", "Tableta 500 mg", 120, 40, 4.50),
    ("MED-107", "Azitromicina", "Suspensión 200 mg/5 ml, frasco 15 ml", 40, 15, 45.00),
    ("MED-108", "Nitrofurantoína", "Cápsula 100 mg", 240, 60, 1.20),
    ("MED-109", "Amlodipino", "Tableta 5 mg", 360, 120, 0.50),
    ("MED-110", "Glibenclamida", "Tableta 5 mg", 300, 100, 0.30),
    ("MED-111", "Sulfato ferroso + ácido fólico (prenatal)", "Tableta 60 mg + 0.4 mg", 900, 300, 0.25),
    ("MED-112", "Loratadina", "Jarabe 5 mg/5 ml, frasco 60 ml", 70, 25, 18.00),
    ("MED-113", "Mupirocina", "Ungüento 2 %, tubo 15 g", 35, 10, 38.00),
    ("MED-114", "Permetrina", "Crema 5 %, tubo 60 g", 30, 10, 42.00),
]
FRASCO_ML = {"MED-101": 120, "MED-102": 120, "MED-004": 120, "MED-105": 10, "MED-107": 15, "MED-112": 60}


def peso_estimado(edad_anios, depto):
    """Peso aproximado (kg) de un niño o adolescente según la edad, algo menor donde hay desnutrición crónica."""
    m = edad_anios * 12
    if m <= 6:
        w = 3.3 + 0.7 * m
    elif m < 12:
        w = 7.5 + 0.3 * (m - 6)
    elif edad_anios <= 5:
        w = 9.5 + 2 * (edad_anios - 1)
    elif edad_anios <= 12:
        w = 2 * edad_anios + 8
    else:
        w = 32 + 5 * min(edad_anios - 12, 5)
    if depto in OCCIDENTE:
        w *= 0.92
    return round(w * R.uniform(0.93, 1.07), 1)


def ml(x):
    return max(0.5, round(x * 2) / 2)


def frascos(codigo, ml_dosis, veces_dia, dias):
    return max(1, math.ceil(ml_dosis * veces_dia * dias / FRASCO_ML[codigo]))


def fmt(x):
    return f"{x:g}"


# Cada función de tratamiento recibe al paciente (edad en años, peso, alergias, crónicos) y devuelve
# (texto del tratamiento, [(código, cantidad, dosis)], notas)
def nino(p):
    """Jarabes y dosis por peso hasta los 12 años o 30 kg; después, presentaciones de adulto."""
    return p["edad"] < 12 and (p["peso"] or 99) < 30


def antipiretico(p, dias=3, motivo="si hay fiebre o dolor"):
    if nino(p):
        d = ml(15 * p["peso"] / 24)            # 15 mg/kg, suspensión de 24 mg/ml
        return ("MED-101", frascos("MED-101", d, 4, dias), f"{fmt(d)} ml cada 6 horas {motivo} (15 mg/kg/dosis), máximo 4 dosis al día")
    return ("MED-001", 4 * dias if dias <= 5 else 30, f"1 tableta cada 6 horas {motivo}, máximo 4 al día")


def antibiotico_amoxi(p, mg_kg_dia, dias, adulto_mg=500, adulto_veces=3):
    """Amoxicilina (o azitromicina si es alérgico a la penicilina)."""
    if "Penicilina" in p["alergias"]:
        if nino(p):
            d = ml(10 * p["peso"] / 40)        # 10 mg/kg/día, suspensión de 40 mg/ml
            return ("MED-107", frascos("MED-107", d, 1, 3), f"{fmt(d)} ml una vez al día por 3 días (alérgico a la penicilina)")
        return ("MED-106", 3, "1 tableta una vez al día por 3 días (alérgico a la penicilina)")
    if nino(p):
        d = ml(mg_kg_dia * p["peso"] / 2 / 50)  # dividido en 2 dosis, suspensión de 50 mg/ml
        return ("MED-004", frascos("MED-004", d, 2, dias), f"{fmt(d)} ml cada 12 horas por {dias} días ({mg_kg_dia} mg/kg/día)")
    caps = adulto_mg // 500
    texto = f"{caps} cápsula{'s' if caps > 1 else ''} cada {24 // adulto_veces} horas por {dias} días"
    return ("MED-003", caps * adulto_veces * dias, texto)


def analgesico_adulto(p, dias=5):
    if p["cronicos"] & {"hta"} or "AINE" in p["alergias"] or p["edad"] >= 65:
        return ("MED-001", 4 * dias, f"1 tableta cada 6 horas por {dias} días (sin antiinflamatorios por su presión o edad)")
    return ("MED-002", 3 * dias, f"1 tableta cada 8 horas con comida por {dias} días")


def t_resfriado(p):
    return ("Líquidos abundantes, lavado nasal con suero fisiológico, reposo. No necesita antibiótico.",
            [antipiretico(p)] if R.random() < 0.6 else [], f"T {R.choice(['37.4', '37.8', '38.1', '38.3'])} °C. Sin dificultad respiratoria.")


def t_faringitis(p):
    dias = 10
    return ("Antibiótico por faringoamigdalitis bacteriana; gárgaras con agua tibia y sal (mayores de 7 años).",
            [antibiotico_amoxi(p, 50, dias), antipiretico(p)], "Amígdalas con exudado, ganglios cervicales dolorosos, sin tos.")


def t_otitis(p):
    dias = 10 if p["edad"] < 2 else 7
    return ("Antibiótico por otitis media aguda; control en 48 a 72 horas si no mejora.",
            [antibiotico_amoxi(p, 90, dias), antipiretico(p)], "Membrana timpánica abombada y enrojecida.")


def t_neumonia(p):
    if p["edad"] < 12:
        txt = "Neumonía sin signos de peligro: manejo en casa, control en 48 horas. Regresar si respira rápido o se hunden las costillas."
        return (txt, [antibiotico_amoxi(p, 90, 5), antipiretico(p)], f"FR {R.randint(44, 52)} por minuto, SatO2 {R.randint(93, 95)} %.")
    return ("Neumonía adquirida en la comunidad, manejo ambulatorio; control en 48 horas.",
            [antibiotico_amoxi(p, 0, 7, adulto_mg=1000, adulto_veces=3), antipiretico(p)],
            f"T 38.{R.randint(2, 9)} °C, FR {R.randint(22, 26)}, SatO2 {R.randint(92, 95)} %. Crepitantes en base derecha.")


def t_bronquiolitis(p):
    return ("Lavado nasal antes de cada toma, lactancia frecuente. Regresar si respira rápido, se hunden las costillas o no come.",
            [antipiretico(p)], f"Sibilancias leves, SatO2 {R.randint(94, 97)} %. Sin tiraje.")


def t_asma(p):
    return ("Crisis leve de asma. Salbutamol con espaciador; plan de acción escrito; evitar humo de leña.",
            [("MED-011", 1, "2 inhalaciones con espaciador cada 4 a 6 horas por 5 días, luego solo si hay falta de aire")],
            f"Sibilancias espiratorias, SatO2 {R.randint(94, 97)} %.")


def t_diarrea(p):
    meds = [("MED-012", 6 if p["edad"] < 10 else 8,
             "1 sobre en 1 litro de agua hervida; dar " + ("50 a 100 ml" if p["edad"] < 2 else "100 a 200 ml" if p["edad"] < 10 else "lo que tolere")
             + " después de cada evacuación")]
    if p["edad"] < 5:
        zinc = "media tableta (10 mg)" if p["edad"] < 0.5 else "1 tableta (20 mg)"
        meds.append(("MED-103", 10 if p["edad"] >= 0.5 else 5, f"{zinc} disuelta una vez al día por 10 días"))
    return ("Plan A de hidratación: seguir alimentando, más líquidos. Regresar si hay sangre, vómitos o no orina.",
            meds, "Sin signos de deshidratación. Mucosas húmedas." if R.random() < 0.8 else "Deshidratación leve; recibió plan B en el servicio y tolera vía oral.")


def t_parasitos(p):
    if p["edad"] < 2:
        return ("Desparasitación; lavado de manos y agua hervida.", [("MED-105", 1, "5 ml (200 mg) en una sola dosis")], None)
    return ("Desparasitación; lavado de manos, agua hervida, uñas cortas.", [("MED-104", 1, "1 tableta masticada en una sola dosis")], None)


def t_dengue(p):
    return ("Dengue sin signos de alarma: reposo, líquidos abundantes. NO usar ibuprofeno, naproxeno ni aspirina. "
            "Regresar de inmediato si hay dolor abdominal intenso, vómitos que no paran o sangrado.",
            [antipiretico(p, 5, "si hay fiebre")], f"T 38.{R.randint(5, 9)} °C, dolor retroocular y mialgias. Prueba de torniquete negativa.")


def t_chik(p):
    return ("Chikungunya: reposo y líquidos; dolor de articulaciones puede durar semanas. Sin antiinflamatorios hasta descartar dengue.",
            [antipiretico(p, 5, "si hay fiebre o dolor")], "Artralgias en manos y tobillos, fiebre de 2 días.")


def t_malaria(p):
    return ("Gota gruesa positiva. Tratamiento supervisado con cloroquina y primaquina según la norma del MSPAS. Notificación inmediata.",
            [], "Fiebre con escalofríos cada 48 horas. Viajó a zona de cultivos.")


def t_varicela(p):
    meds = [antipiretico(p, 5, "si hay fiebre")]
    if p["edad"] >= 2:
        meds.append(("MED-112", 1, "5 ml una vez al día por 5 días para la picazón") if p["edad"] < 6
                    else ("MED-010", 5, "1 tableta una vez al día por 5 días para la picazón"))
    return ("Varicela: uñas cortas, baño diario, no aspirina. No ir a la escuela hasta que todas las lesiones tengan costra.", meds,
            "Vesículas en diferentes etapas en tronco y cara.")


def t_manopieboca(p):
    return ("Enfermedad de mano, pie y boca: líquidos fríos, alimentos blandos; contagiosa por 7 días.",
            [antipiretico(p, 3, "si hay fiebre o dolor")], "Úlceras en la boca y lesiones en palmas y plantas.")


def t_hepatitis(p):
    return ("Hepatitis A: reposo, dieta sin grasas, nada de alcohol ni medicamentos sin receta. Lavado de manos en la familia.",
            [], "Ictericia leve, coluria. Sin signos de falla hepática.")


def t_desnutricion_mod(p):
    return ("Desnutrición aguda moderada: alimento terapéutico listo para el consumo (ATLC) según peso, control semanal, "
            "consejería en lactancia y alimentación. Seguimiento por el puesto de salud.", [], None)


def t_desnutricion_sev(p):
    return ("Desnutrición aguda severa: se refiere al hospital (Centro de Recuperación Nutricional). Notificación obligatoria.", [], None)


def t_hta(p, control):
    med = p.setdefault("antihipertensivo", R.choice(["MED-005", "MED-005", "MED-013", "MED-109"]))
    dosis = {"MED-005": (30, "1 tableta cada 24 horas por la mañana"), "MED-013": (60, "1 tableta cada 12 horas"),
             "MED-109": (30, "1 tableta cada 24 horas")}[med]
    pa = f"PA {R.randint(132, 158)}/{R.randint(84, 98)} mmHg" if control == 0 else f"PA {R.randint(122, 142)}/{R.randint(76, 90)} mmHg"
    return ("Hipertensión arterial en control: dieta baja en sal, caminar 30 minutos al día, tomar la medicina sin falta.",
            [(med, *dosis)], pa + (". Inicia tratamiento." if control == 0 else ". Control mensual."))


def t_dm(p, control):
    meds = [("MED-006", 60, "1 tableta cada 12 horas con el desayuno y la cena")]
    if p.setdefault("glibenclamida", R.random() < 0.3):
        meds.append(("MED-110", 30, "1 tableta antes del desayuno"))
    g = R.randint(150, 210) if control == 0 else R.randint(110, 150)
    return ("Diabetes tipo 2: dieta sin azúcar ni harinas refinadas, ejercicio, revisar los pies cada día.",
            meds, f"Glucosa en ayunas {g} mg/dL.")


def t_ivu(p):
    return ("Infección urinaria no complicada: tomar mucha agua, no aguantar las ganas de orinar.",
            [("MED-108", 10, "1 cápsula cada 12 horas con comida por 5 días")], "Disuria y polaquiuria; orina con nitritos positivos.")


def t_gastritis(p):
    return ("Gastritis: comer a sus horas, evitar café, picante, alcohol y antiinflamatorios.",
            [("MED-009", 28, "1 cápsula cada 24 horas en ayunas por 4 semanas")], None)


def t_lumbalgia(p):
    return ("Lumbalgia mecánica: calor local, evitar cargar peso, ejercicios de estiramiento.", [analgesico_adulto(p)], "Sin déficit neurológico.")


def t_embarazo(p):
    semanas = R.randint(10, 34)
    return ("Control prenatal. Signos de peligro: sangrado, dolor de cabeza fuerte, hinchazón, fiebre, que el bebé no se mueva.",
            [("MED-111", 30, "1 tableta al día")], f"{semanas} semanas de gestación, PA {R.randint(100, 118)}/{R.randint(62, 76)} mmHg, frecuencia fetal {R.randint(135, 152)}.")


def t_anemia(p):
    return ("Anemia por falta de hierro: alimentos con hierro (hígado, frijol, hojas verdes) con limón; control de hemoglobina en 1 mes.",
            [("MED-014", 30, "1 tableta al día con jugo de naranja, por 3 meses")], f"Hemoglobina {R.randint(88, 105) / 10} g/dL.")


def t_impetigo(p):
    return ("Impétigo: lavar con agua y jabón y quitar las costras antes de aplicar el ungüento; no compartir toallas.",
            [("MED-113", 1, "aplicar 3 veces al día por 5 días")], None)


def t_escabiosis(p):
    return ("Escabiosis (sarna): tratar a toda la familia el mismo día y lavar con agua caliente la ropa de cama.",
            [("MED-114", 1, "aplicar del cuello a los pies por la noche y bañarse a las 8 a 14 horas; repetir en 7 días")], None)


def t_control_nino(p):
    meds = []
    if p["edad"] >= 2 and R.random() < 0.5:
        meds = [("MED-104", 1, "1 tableta masticada en una sola dosis (desparasitación cada 6 meses)")]
    return ("Control de crecimiento y desarrollo. Lactancia y alimentación según la edad; vacunas al día.", meds, None)


def t_vacuna(p):
    return ("Aplicación de vacunas del esquema según la edad.", [], None)


def t_esguince(p):
    return ("Esguince de tobillo grado I: reposo, hielo 20 minutos 3 veces al día, vendaje y pie elevado.", [analgesico_adulto(p, 5)], None)


def t_herida(p):
    return ("Herida limpia en mano: lavado, sutura con 3 puntos, curación diaria. Retiro de puntos en 7 a 10 días. Td aplicada.",
            [analgesico_adulto(p, 3)], None)


def t_epoc(p):
    return ("EPOC por humo de leña: salbutamol cuando haya falta de aire, estufa mejorada, vacuna de influenza.",
            [("MED-011", 1, "2 inhalaciones cada 6 horas si hay falta de aire")], f"SatO2 {R.randint(89, 93)} %, sibilancias dispersas.")


# clave: (código, [diagnósticos], edad (min, max), sexo, peso por grupo de edad (0-4, 5-14, 15-59, 60+), regiones, tratamiento, grupo)
C = {
    "resfriado": ("J00", ["Rinofaringitis aguda (resfriado común)", "Resfriado común"], (0.2, 90), None, (14, 10, 6, 4), None, t_resfriado),
    "ira": ("J06.9", ["Infección respiratoria aguda superior", "IRA superior, sin neumonía"], (0.2, 90), None, (12, 8, 5, 4), None, t_resfriado),
    "faringitis": ("J03.9", ["Amigdalitis aguda bacteriana", "Faringoamigdalitis aguda"], (3, 55), None, (2, 6, 3, 0.5), None, t_faringitis),
    "otitis": ("H66.9", ["Otitis media aguda"], (0.5, 10), None, (6, 3, 0, 0), None, t_otitis),
    "neumonia": ("J18.9", ["Neumonía adquirida en la comunidad", "Neumonía sin signos de peligro"], (0.25, 95), None, (5, 1, 0.5, 3), None, t_neumonia),
    "bronquiolitis": ("J21.9", ["Bronquiolitis aguda"], (0.1, 1.9), None, (4, 0, 0, 0), None, t_bronquiolitis),
    "asma": ("J45.9", ["Asma, crisis leve"], (4, 50), None, (0, 2, 1, 0), None, t_asma),
    "diarrea": ("A09", ["Diarrea aguda sin deshidratación", "Gastroenteritis aguda"], (0.3, 90), None, (12, 5, 3, 2), None, t_diarrea),
    "parasitos": ("B82.9", ["Parasitismo intestinal"], (1, 14), None, (3, 5, 0, 0), None, t_parasitos),
    "dengue": ("A90", ["Dengue sin signos de alarma"], (2, 75), None, (1, 4, 4, 2), TIERRA_BAJA, t_dengue),
    "chik": ("A92.0", ["Chikungunya"], (12, 75), None, (0, 1, 2, 1), TIERRA_BAJA, t_chik),
    "malaria": ("B54", ["Paludismo (malaria), gota gruesa positiva"], (5, 65), None, (0, 0.6, 1, 0.3), MALARIA, t_malaria),
    "varicela": ("B01.9", ["Varicela sin complicaciones"], (1, 14), None, (2, 3, 0, 0), None, t_varicela),
    "manopieboca": ("B08.4", ["Enfermedad de mano, pie y boca"], (1, 5), None, (2, 0, 0, 0), None, t_manopieboca),
    "hepatitis": ("B15.9", ["Hepatitis A"], (3, 15), None, (0.5, 0.8, 0, 0), None, t_hepatitis),
    "desnut_mod": ("E44.0", ["Desnutrición aguda moderada"], (0.5, 4.9), None, (3, 0, 0, 0), CORREDOR_SECO | OCCIDENTE | {"16"}, t_desnutricion_mod),
    "desnut_sev": ("E43", ["Desnutrición aguda severa"], (0.5, 4.9), None, (0.6, 0, 0, 0), CORREDOR_SECO | OCCIDENTE | {"16"}, t_desnutricion_sev),
    "hta": ("I10", ["Hipertensión arterial esencial"], (40, 92), None, (0, 0, 3, 9), None, None),
    "dm": ("E11.9", ["Diabetes mellitus tipo 2"], (35, 88), None, (0, 0, 3, 6), None, None),
    "ivu": ("N39.0", ["Infección de vías urinarias no complicada"], (16, 65), "F", (0, 0, 5, 1), None, t_ivu),
    "gastritis": ("K29.7", ["Gastritis aguda", "Gastritis"], (16, 80), None, (0, 0, 4, 2), None, t_gastritis),
    "lumbalgia": ("M54.5", ["Lumbalgia mecánica"], (20, 75), None, (0, 0, 4, 2), None, t_lumbalgia),
    "embarazo": ("Z34.9", ["Control prenatal, embarazo normal"], (16, 40), "F", (0, 0, 6, 0), None, t_embarazo),
    "anemia": ("D50.9", ["Anemia por deficiencia de hierro"], (15, 50), "F", (0, 0, 2, 0), None, t_anemia),
    "impetigo": ("L01.0", ["Impétigo"], (2, 10), None, (1, 2, 0, 0), None, t_impetigo),
    "escabiosis": ("B86", ["Escabiosis (sarna)"], (2, 80), None, (0.5, 1.5, 0.8, 0.5), None, t_escabiosis),
    "control_nino": ("Z00.1", ["Control de niño sano"], (0, 4.9), None, (10, 0, 0, 0), None, t_control_nino),
    "vacuna": ("Z23", ["Vacunación según esquema"], (0, 4.9), None, (5, 0, 0, 0), None, t_vacuna),
    "esguince": ("S93.4", ["Esguince de tobillo"], (12, 60), None, (0, 1, 2, 0.3), None, t_esguince),
    "herida": ("S61.9", ["Herida cortante en mano"], (15, 65), None, (0, 0, 1.5, 0.3), None, t_herida),
    "epoc": ("J44.9", ["EPOC por exposición a humo de leña"], (55, 92), "F", (0, 0, 0, 2), OCCIDENTE | MAYA_QEQCHI | {"04"}, t_epoc),
}
GRUPO_DE = {"resfriado": "respiratorias", "ira": "respiratorias", "faringitis": "respiratorias", "neumonia": "respiratorias",
            "bronquiolitis": "respiratorias", "diarrea": "diarreicas", "dengue": "arbovirosis", "chik": "arbovirosis",
            "malaria": "paludismo", "hepatitis": "hepatitis", "varicela": "exantematicas", "manopieboca": "exantematicas",
            "desnut_mod": "desnutricion", "desnut_sev": "desnutricion", "hta": "hipertension", "dm": "diabetes"}


def banda(edad):
    return 0 if edad < 5 else 1 if edad < 15 else 2 if edad < 60 else 3


def elegir_condicion(p, depto, dias_atras):
    edad = p["edad_dias"] / 365.25 - dias_atras / 365.25
    opciones = []
    for k, (codigo, _, (a, b), sexo, pesos, regiones, _) in C.items():
        if not a <= edad <= b or (sexo and sexo != p["sexo"]) or (regiones and depto not in regiones):
            continue
        if p["mun"] == "1301" and GRUPO_DE.get(k) == "exantematicas":
            continue                                # ahí las pruebas del backend crean su propio brote
        if k in ("hta", "dm"):
            continue                                # los crónicos se asignan aparte
        w = pesos[banda(edad)]
        if k in ("desnut_mod", "desnut_sev") and depto in OCCIDENTE:
            w *= 1.2
        if w > 0:
            opciones.append((k, w))
    total = sum(w for _, w in opciones)
    x = R.uniform(0, total)
    for k, w in opciones:
        x -= w
        if x <= 0:
            return k
    return opciones[-1][0]


# --------------------------------------------------------------------------- población
def municipios_elegidos():
    por_depto = {}
    for cod in sorted(MUNICIPIOS):
        if cod.endswith("00") or cod in EXCLUIR:
            continue
        por_depto.setdefault(cod[:2], []).append(cod)
    elegidos = []
    for depto, lista in sorted(por_depto.items()):
        n = min(len(lista), max(4, min(10, math.ceil(len(lista) * 0.5))))
        cabecera = [c for c in lista if c.endswith("01")]
        resto = [c for c in lista if c not in cabecera]
        R.shuffle(resto)
        elegidos += cabecera + resto[: n - len(cabecera)]
    return elegidos


def fecha_nac_dias():
    """Edad en días: 0-4 años 22 %, 5-14 20 %, 15-59 45 %, 60+ 13 %."""
    x = R.random()
    if x < 0.22:
        return R.randint(20, 5 * 365 - 1)
    if x < 0.42:
        return R.randint(5 * 365, 15 * 365 - 1)
    if x < 0.87:
        return R.randint(15 * 365, 60 * 365 - 1)
    return R.randint(60 * 365, 92 * 365)


def dia_atencion(reciente, edad_dias):
    if reciente:
        d = R.randint(1, 27)
    else:
        d = R.randint(0, 34) if R.random() < 0.5 else R.randint(35, 180)
    return min(d, max(0, edad_dias - 7))         # nunca antes de nacer


def hora(dias):
    if dias == 0:                                   # las de hoy, temprano (no en el futuro)
        return f"07:{R.choice(['10', '25', '40', '55'])}:00"
    return f"{R.randint(7, 16):02d}:{R.choice(['05', '12', '20', '28', '35', '43', '50', '57'])}:00"


pacientes, atenciones = [], []
secuencia = 0
for mun in municipios_elegidos():
    depto = mun[:2]
    cabecera = mun.endswith("01")
    n = R.randint(7, 10) if cabecera else R.randint(3, 6)
    if depto == "01":
        n += 2
    for i in range(n):
        secuencia += 1
        sexo = "F" if R.random() < 0.53 else "M"
        edad_dias = fecha_nac_dias()
        anio = 2026 - edad_dias // 365
        edad = edad_dias / 365.25
        p = {"cui": f"39{secuencia:07d}{mun}", "nombre": nombre(sexo, anio, depto), "sexo": sexo, "edad_dias": edad_dias,
             "edad": edad, "mun": mun, "depto": depto,
             "zona": R.choice(ZONAS_CAB) if cabecera and R.random() < 0.7 else R.choice(ZONAS),
             "seguro": "IGSS" if 18 <= edad < 65 and R.random() < 0.22 else "Privado" if R.random() < 0.03 else "Ninguno",
             "alergias": R.choices(["", "Penicilina", "AINE (ibuprofeno, naproxeno)", "Sulfas"], [90, 6, 2, 2])[0],
             "cronicos": set()}
        p["peso"] = peso_estimado(edad, depto) if edad < 18 else None
        p["telefono"] = telefono() if R.random() < 0.75 else None
        if edad < 18:
            ap_madre = p["nombre"].split()[-1]
            p["cuidador"] = f"{R.choice(M_MAYOR + M_JOVEN)} {ap_madre} (madre)"
            p["telefono"] = p["telefono"] or telefono()
        else:
            p["cuidador"] = None
        if edad >= 40 and R.random() < (0.38 if edad >= 60 else 0.16):
            p["cronicos"].add("hta")
        if edad >= 35 and R.random() < (0.2 if edad >= 60 else 0.1):
            p["cronicos"].add("dm")
        pacientes.append(p)

        # Atenciones: los 3 primeros de cada municipio con una atención reciente (el mapa de 4 semanas se llena)
        reciente = i < 3
        if p["cronicos"]:
            inicio = R.randint(60, 150)
            for control, d in enumerate([inicio, inicio - 30, inicio - 60, inicio - 90][: R.randint(2, 4)]):
                if d < 1:
                    break
                for k in sorted(p["cronicos"]):
                    atenciones.append({"p": p, "k": k, "d": d, "control": control})
        for _ in range(1 if R.random() < 0.7 else 2):
            d = dia_atencion(reciente, edad_dias)
            reciente = False
            atenciones.append({"p": p, "k": elegir_condicion(p, depto, d), "d": d})

# Brotes planeados: casos nuevos en las últimas 4 semanas del municipio (pacientes nuevos)
for (mun, grupo), (semana, antes) in BROTES.items():
    k = "dengue" if grupo == "arbovirosis" else "diarrea"
    for j in range(semana + antes):
        secuencia += 1
        sexo = R.choice("MF")
        edad_dias = R.randint(3 * 365, 50 * 365) if k == "dengue" else R.randint(300, 9 * 365)
        edad = edad_dias / 365.25
        p = {"cui": f"39{secuencia:07d}{mun}", "nombre": nombre(sexo, 2026 - edad_dias // 365, mun[:2]), "sexo": sexo,
             "edad_dias": edad_dias, "edad": edad, "mun": mun, "depto": mun[:2], "zona": R.choice(ZONAS_CAB[:5]),
             "seguro": "Ninguno", "alergias": "", "cronicos": set(), "peso": peso_estimado(edad, mun[:2]) if edad < 18 else None,
             "telefono": telefono(), "cuidador": None}
        if edad < 18:
            p["cuidador"] = f"{R.choice(M_JOVEN)} {p['nombre'].split()[-1]} (madre)"
        pacientes.append(p)
        atenciones.append({"p": p, "k": k, "d": R.randint(0, 6) if j < semana else R.randint(8, 34), "brote": True})

# Ningún otro brote: se revisa con la regla del backend, hoy y en los 7 días siguientes, por
# enfermedad (municipio, grupo) y por municipio con todas sus atenciones (municipio, "*"), que es
# el borde rojo del mapa.
PERMITIDAS = set(BROTES) | {(m, "*") for m, _ in BROTES}


def alertas(desfase):
    semana, previo = Counter(), Counter()
    for a in atenciones:
        d = a["d"] + desfase
        for clave in ((a["p"]["mun"], "*"), (a["p"]["mun"], GRUPO_DE.get(a["k"]))):
            if clave[1] is None:
                continue
            if d <= 6:
                semana[clave] += 1
            elif d <= 34:
                previo[clave] += 1
    return {k for k, n in semana.items() if n >= 3 and n > 2 * round(previo[k] / 4, 1)}


for _ in range(2000):
    sobran = set().union(*(alertas(s) for s in range(0, 8))) - PERMITIDAS
    if not sobran:
        break
    for a in sorted(atenciones, key=lambda a: a["d"]):
        clave = {(a["p"]["mun"], "*"), (a["p"]["mun"], GRUPO_DE.get(a["k"]))}
        if clave & sobran and a["d"] <= 13 and not a.get("brote") and a["p"]["edad_dias"] > 130:
            a["d"] = R.randint(14, min(120, a["p"]["edad_dias"] - 7))
            break
else:
    raise SystemExit("no se pudieron quitar las alertas no planeadas")
assert alertas(0) == PERMITIDAS, alertas(0)


# --------------------------------------------------------------------------- crecimiento y vacunación
def medicion(p, dias_atras, z_talla, z_peso):
    edad = p["edad_dias"] - dias_atras
    if edad < 0:
        return None
    talla = crecimiento.curva("talla_edad", p["sexo"], z_talla, [edad])[0]["y"]
    tabla = "peso_longitud" if edad < 731 else "peso_talla"
    puntos = crecimiento.curva(tabla, p["sexo"], z_peso, [round(talla, 1)])
    peso = puntos[0]["y"] if puntos else crecimiento.curva("peso_edad", p["sexo"], z_peso, [edad])[0]["y"]
    return (dias_atras, round(peso, 1), round(talla, 1))


# Generador aparte: así las mediciones se pueden rehacer sin cambiar pacientes ni atenciones ya cargados.
# Primero los niños con desnutrición (su medición debe coincidir con el diagnóstico), luego los controles.
R2 = random.Random(5)
PRIORIDAD = {"desnut_sev": 0, "desnut_mod": 1, "control_nino": 2}
mediciones, notas_crecimiento = [], []
for a in sorted((a for a in atenciones if a["k"] in PRIORIDAD), key=lambda a: (PRIORIDAD[a["k"]], a["d"])):
    p = a["p"]
    if p.get("medido"):
        continue
    p["medido"] = True
    zt = max(-3.8, min(1.2, R2.gauss(Z_TALLA[p["depto"]], 0.8)))
    zp = {"desnut_mod": R2.uniform(-2.9, -2.1), "desnut_sev": R2.uniform(-3.6, -3.1)}.get(a["k"], max(-1.6, min(2.2, R2.gauss(0.2, 0.8))))
    z_dia = None                                    # z de talla/edad de la medición del día de la atención
    for n, extra in enumerate((0, 75, 150)[: R2.randint(1, 3)]):
        m = medicion(p, a["d"] + extra, zt + R2.uniform(-0.15, 0.15), (zp if n == 0 else max(-1.8, zp + 0.8)))
        if m:
            mediciones.append((p, *m))
            if n == 0:
                z_dia = crecimiento.puntaje_z("talla_edad", p["sexo"], p["edad_dias"] - a["d"], m[2])
    if a["k"] == "control_nino":
        notas_crecimiento.append((p, a["d"], f"Retardo del crecimiento (talla/edad z {z_dia:.1f}). Consejería en alimentación y micronutrientes."
                                  if z_dia is not None and z_dia < -2 else None))

ESQUEMA = [(0, "BCG y hepatitis B"), (60, "Pentavalente, polio, rotavirus y neumococo (1.ª dosis)"),
           (120, "Pentavalente, polio, rotavirus y neumococo (2.ª dosis)"), (180, "Pentavalente y polio (3.ª dosis)"),
           (365, "SPR y neumococo (refuerzo)"), (540, "SPR, DPT y polio (refuerzo de 18 meses)"), (1460, "DPT y polio (refuerzo de 4 años)")]
vacunas = []
for p in pacientes:
    if p["edad"] >= 15 or R.random() > 0.6:
        continue
    if p["edad"] < 5:
        tocan = [v for d, v in ESQUEMA if d <= p["edad_dias"]]
        pendientes = [v for v in tocan[-2:] if R.random() < 0.35]
        vacunas.append((p, 0, not pendientes, ", ".join(pendientes) or None))
    else:
        pend = []
        if p["sexo"] == "F" and p["edad"] >= 10 and R.random() < 0.5:
            pend.append("VPH")
        if R.random() < 0.3:
            pend.append("Td (escolar)")
        vacunas.append((p, 1, not pend, ", ".join(pend) or None))


# --------------------------------------------------------------------------- SQL
def q(v):
    if v is None:
        return "NULL"
    if isinstance(v, bool):
        return "1" if v else "0"
    if isinstance(v, (int, float)):
        return repr(v)
    return "'" + str(v).replace("\\", "\\\\").replace("'", "''") + "'"


def cuando(dias, h):
    return f"TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL {dias} DAY), '{h}')"


lineas = []
w = lineas.append
salidas = Counter()
for p in pacientes:
    w(f"    INSERT INTO pacientes (cui, nombre_completo, fecha_nacimiento, genero, telefono, tipo_seguro, cuidador, alergias, municipio, zona, fecha_registro) "
      f"VALUES ({q(p['cui'])}, {q(p['nombre'])}, DATE_SUB(CURDATE(), INTERVAL {p['edad_dias']} DAY), {q(p['sexo'])}, {q(p['telefono'])}, "
      f"{q(p['seguro'])}, {q(p['cuidador'])}, {q(p['alergias'] or None)}, {q(p['mun'])}, {q(p['zona'])}, DATE_SUB(NOW(), INTERVAL 200 DAY));")

n_recetas = 0
for a in sorted(atenciones, key=lambda a: -a["d"]):
    p, k, d = a["p"], a["k"], a["d"]
    codigo, textos = C[k][0], C[k][1]
    p_eval = dict(p, edad=(p["edad_dias"] - d) / 365.25)
    if k == "hta":
        trat, meds, nota = t_hta(p, a["control"])
    elif k == "dm":
        trat, meds, nota = t_dm(p, a["control"])
    else:
        trat, meds, nota = C[k][6](p_eval)
    if p["peso"] and nino(p_eval) and meds:
        nota = f"Peso {p['peso']} kg. " + (nota or "")
    h = hora(d)
    medico = MEDICOS[(int(p["mun"]) + d) % len(MEDICOS)]
    w(f"    INSERT INTO expedientes_clinicos (paciente_id, diagnostico, codigo_cie10, tratamiento, notas, fecha_atencion) "
      f"VALUES ((SELECT id FROM pacientes WHERE cui = {q(p['cui'])}), {q(R.choice(textos))}, {q(codigo)}, {q(trat)}, {q(nota)}, {cuando(d, h)});")
    if not meds:
        continue
    n_recetas += 1
    despachada = d >= 1 or R.random() < 0.4
    hh, mm = int(h[:2]), int(h[3:5])
    hd = f"{min(hh + 1, 18):02d}:{mm:02d}:00"
    w(f"    SET @e = LAST_INSERT_ID();")
    w(f"    INSERT INTO recetas (id_paciente, medico_nombre, expediente_id, fecha, indicaciones, estado, fecha_despacho, codigo_verificacion) "
      f"VALUES ((SELECT id FROM pacientes WHERE cui = {q(p['cui'])}), {q(medico)}, @e, {cuando(d, h)}, {q(trat.split('. ')[0].rstrip('.') + '.')}, "
      f"{q('DESPACHADA' if despachada else 'PENDIENTE')}, {cuando(d, hd) if despachada else 'NULL'}, "
      f"REPLACE(REPLACE(TO_BASE64(RANDOM_BYTES(9)), '+', '-'), '/', '_'));")
    w("    SET @r = LAST_INSERT_ID();")
    for med, cant, dosis in meds:
        w(f"    INSERT INTO detalle_receta (id_receta, id_medicamento, cantidad, dosis) VALUES (@r, (SELECT id_medicamento FROM medicamentos WHERE codigo = {q(med)}), {cant}, {q(dosis)});")
        if despachada:
            salidas[med] += cant
            w(f"    INSERT INTO movimientos_inventario (id_medicamento, tipo_movimiento, cantidad, fecha, observacion, receta_id, usuario) "
              f"VALUES ((SELECT id_medicamento FROM medicamentos WHERE codigo = {q(med)}), 'SALIDA', -{cant}, {cuando(d, hd)}, 'Despacho de receta', @r, 'farmacia1');")

# Crecimiento: va aparte porque también se puede REHACER sobre una población ya cargada (versión 2).
# Las fechas se cuentan desde @carga, el día en que se cargó la población (fecha_registro + 200 días).
REGISTRO_V2 = "Enfermería del puesto de salud"
crec = []
for p, dias, peso, talla in mediciones:
    crec.append(f"    INSERT INTO mediciones_crecimiento (paciente_id, fecha, peso_kg, talla_cm, registrado_por, fecha_registro) "
                f"VALUES ((SELECT id FROM pacientes WHERE cui = {q(p['cui'])}), DATE_SUB(@carga, INTERVAL {dias} DAY), {peso}, {talla}, '{REGISTRO_V2}', NOW());")
for p, dias, extra in notas_crecimiento:
    nueva = f"CONCAT_WS(' ', NULLIF(TRIM(SUBSTRING_INDEX(COALESCE(e.notas, ''), 'Retardo del crecimiento', 1)), ''), {q(extra)})"
    crec.append(f"    UPDATE expedientes_clinicos e JOIN pacientes p ON p.id = e.paciente_id SET e.notas = NULLIF({nueva}, '') "
                f"WHERE p.cui = {q(p['cui'])} AND e.codigo_cie10 = 'Z00.1' AND DATE(e.fecha_atencion) = DATE_SUB(@carga, INTERVAL {dias} DAY);")
for p, estudiante, completo, pendientes in vacunas:
    w(f"    INSERT INTO vacunacion (paciente_id, es_estudiante, esquema_completo, vacunas_pendientes) "
      f"VALUES ((SELECT id FROM pacientes WHERE cui = {q(p['cui'])}), {estudiante}, {q(completo)}, {q(pendientes)});")

# Inventario: los medicamentos nuevos entran con su existencia + lo despachado; a los de antes se les
# registra la compra de lo que se despachó, así el kardex cuadra y la existencia no cambia.
inventario = []
for cod, nom, pres, exi, mini, precio in NUEVOS:
    inventario.append(f"    INSERT INTO medicamentos (codigo, nombre, presentacion, existencia, stock_minimo, precio) VALUES ({q(cod)}, {q(nom)}, {q(pres)}, {exi}, {mini}, {precio});")
    inventario.append(f"    INSERT INTO movimientos_inventario (id_medicamento, tipo_movimiento, cantidad, fecha, observacion, usuario) "
                      f"VALUES (LAST_INSERT_ID(), 'ENTRADA', {exi + salidas[cod]}, DATE_SUB(NOW(), INTERVAL 185 DAY), 'Inventario inicial', 'farmacia1');")
nuevos = {c for c, *_ in NUEVOS}
for cod, cant in sorted(salidas.items()):
    if cod not in nuevos:
        inventario.append(f"    INSERT INTO movimientos_inventario (id_medicamento, tipo_movimiento, cantidad, fecha, observacion, usuario) "
                          f"VALUES ((SELECT id_medicamento FROM medicamentos WHERE codigo = {q(cod)}), 'ENTRADA', {cant}, DATE_SUB(NOW(), INTERVAL 185 DAY), 'Compra (abastecimiento semestral)', 'farmacia1');")

primero = pacientes[0]["cui"]
deptos = len({p["depto"] for p in pacientes})
muns = len({p["mun"] for p in pacientes})
resumen = (f"{len(pacientes)} pacientes en {muns} municipios de {deptos} departamentos, {len(atenciones)} atenciones, "
           f"{n_recetas} recetas, {len(mediciones)} mediciones de crecimiento, {len(vacunas)} registros de vacunación")

with open(SALIDA, "w", encoding="utf-8", newline="\n") as f:
    f.write(f"""-- ==========================================================================
-- POBLACIÓN DE DEMOSTRACIÓN DE TODO EL PAÍS (datos FICTICIOS)
-- ==========================================================================
-- ARCHIVO GENERADO por generar_demo_poblacion.py: no se edita a mano.
-- {resumen}.
-- Diagnósticos coherentes con la edad, el sexo y la región; dosis de niños por peso; se respetan
-- las alergias. Posibles brotes planeados: dengue en Escuintla y diarreas en Cobán.
-- Requiere datos_demo.sql (catálogo de farmacia) y el backend actualizado (residencia y crecimiento).
-- Es seguro correrlo más de una vez: si ya está cargado, no hace nada.
-- Las fechas son relativas al día de carga. Uso:  mysql -u root -p < demo_poblacion.sql
-- ==========================================================================
SET NAMES utf8mb4;
USE salud_db;

DROP PROCEDURE IF EXISTS cargar_poblacion_demo;
DELIMITER //
CREATE PROCEDURE cargar_poblacion_demo()
BEGIN
  IF (SELECT COUNT(*) FROM medicamentos WHERE codigo = 'MED-001') = 0 THEN
    SELECT 'Primero cargue datos_demo.sql' AS resultado;
  ELSEIF (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'mediciones_crecimiento') = 0
      OR (SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = DATABASE() AND table_name = 'pacientes' AND column_name = 'municipio') = 0 THEN
    SELECT 'Primero actualice el backend (crea la residencia y el crecimiento infantil)' AS resultado;
  ELSEIF (SELECT COUNT(*) FROM pacientes WHERE cui = '{primero}') > 0 THEN
    IF (SELECT COUNT(*) FROM mediciones_crecimiento WHERE registrado_por = '{REGISTRO_V2}') > 0 THEN
      SELECT 'La población de demostración ya estaba cargada' AS resultado;
    ELSE
      -- Cargada con la versión 1: se rehacen solo las mediciones de crecimiento (y sus notas)
      SET @carga = (SELECT DATE(fecha_registro) + INTERVAL 200 DAY FROM pacientes WHERE cui = '{primero}');
      DELETE m FROM mediciones_crecimiento m JOIN pacientes p ON p.id = m.paciente_id
        WHERE p.cui LIKE '39%' AND LENGTH(p.cui) = 13 AND m.registrado_por = 'Enfermería';
""")
    f.write("\n".join("  " + x for x in crec) + "\n")
    f.write(f"""      SELECT 'Crecimiento infantil de la población actualizado ({len(mediciones)} mediciones)' AS resultado;
    END IF;
  ELSE
    SET @carga = CURDATE();
""")
    f.write("\n".join(inventario) + "\n")
    f.write("\n".join(lineas) + "\n")
    f.write("\n".join(crec) + "\n")
    f.write(f"""    SELECT '{resumen}' AS resultado;
  END IF;
END //
DELIMITER ;

CALL cargar_poblacion_demo();
DROP PROCEDURE cargar_poblacion_demo;
""")
print(resumen)
print("brotes:", sorted(alertas(0)))
print("salidas:", dict(salidas))
