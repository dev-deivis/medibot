"""
MediBot — Seed de medicamentos en Firestore
Uso:
  1. Coloca serviceAccountKey.json en esta carpeta (scripts/)
  2. pip install firebase-admin --break-system-packages
  3. python3 scripts/seed_firestore.py
"""

import firebase_admin
from firebase_admin import credentials, firestore
import os

# Inicializar Firebase
script_dir = os.path.dirname(os.path.abspath(__file__))
key_path = os.path.join(script_dir, 'serviceAccountKey.json')

if not os.path.exists(key_path):
    print("❌ No se encontró serviceAccountKey.json en scripts/")
    print("   Descárgala desde Firebase Console → Configuración → Cuentas de servicio")
    exit(1)

cred = credentials.Certificate(key_path)
firebase_admin.initialize_app(cred)
db = firestore.client()

# ─── Medicamentos ────────────────────────────────────────────────────────────
medications = [
    # Analgésicos / Antiinflamatorios
    {
        "name": "Paracetamol",
        "nameLower": "paracetamol",
        "genericName": "Paracetamol",
        "brand": "Genérico",
        "dosage": "500mg",
        "form": "Tableta",
        "description": "Analgésico y antipirético. Indicado para el alivio del dolor leve a moderado y la fiebre.",
        "activeIngredients": ["Paracetamol"],
    },
    {
        "name": "Tylenol",
        "nameLower": "tylenol",
        "genericName": "Paracetamol",
        "brand": "Johnson & Johnson",
        "dosage": "500mg",
        "form": "Tableta",
        "description": "Analgésico y antipirético de marca. Contiene paracetamol como principio activo.",
        "activeIngredients": ["Paracetamol"],
    },
    {
        "name": "Ibuprofeno",
        "nameLower": "ibuprofeno",
        "genericName": "Ibuprofeno",
        "brand": "Genérico",
        "dosage": "400mg",
        "form": "Tableta",
        "description": "Antiinflamatorio no esteroideo (AINE). Alivia el dolor, la inflamación y la fiebre.",
        "activeIngredients": ["Ibuprofeno"],
    },
    {
        "name": "Advil",
        "nameLower": "advil",
        "genericName": "Ibuprofeno",
        "brand": "Pfizer",
        "dosage": "400mg",
        "form": "Tableta",
        "description": "Antiinflamatorio no esteroideo de marca. Alivia el dolor muscular, de cabeza y fiebre.",
        "activeIngredients": ["Ibuprofeno"],
    },
    {
        "name": "Diclofenaco",
        "nameLower": "diclofenaco",
        "genericName": "Diclofenaco sódico",
        "brand": "Genérico",
        "dosage": "50mg",
        "form": "Tableta",
        "description": "AINE indicado para artritis, dolor muscular y procesos inflamatorios.",
        "activeIngredients": ["Diclofenaco sódico"],
    },
    {
        "name": "Voltaren",
        "nameLower": "voltaren",
        "genericName": "Diclofenaco sódico",
        "brand": "Novartis",
        "dosage": "50mg",
        "form": "Tableta",
        "description": "Antiinflamatorio de marca ampliamente usado para dolor articular y muscular.",
        "activeIngredients": ["Diclofenaco sódico"],
    },
    # Antibióticos
    {
        "name": "Amoxicilina",
        "nameLower": "amoxicilina",
        "genericName": "Amoxicilina",
        "brand": "Genérico",
        "dosage": "500mg",
        "form": "Cápsula",
        "description": "Antibiótico de amplio espectro del grupo de las penicilinas. Trata infecciones bacterianas.",
        "activeIngredients": ["Amoxicilina"],
    },
    {
        "name": "Amoxil",
        "nameLower": "amoxil",
        "genericName": "Amoxicilina",
        "brand": "GlaxoSmithKline",
        "dosage": "500mg",
        "form": "Cápsula",
        "description": "Antibiótico de marca de amplio espectro. Trata infecciones respiratorias, urinarias y más.",
        "activeIngredients": ["Amoxicilina"],
    },
    {
        "name": "Azitromicina",
        "nameLower": "azitromicina",
        "genericName": "Azitromicina",
        "brand": "Genérico",
        "dosage": "500mg",
        "form": "Tableta",
        "description": "Antibiótico macrólido indicado para infecciones respiratorias y de piel.",
        "activeIngredients": ["Azitromicina"],
    },
    {
        "name": "Zithromax",
        "nameLower": "zithromax",
        "genericName": "Azitromicina",
        "brand": "Pfizer",
        "dosage": "500mg",
        "form": "Tableta",
        "description": "Antibiótico de marca. Tratamiento de neumonía, sinusitis y faringitis bacteriana.",
        "activeIngredients": ["Azitromicina"],
    },
    {
        "name": "Ciprofloxacino",
        "nameLower": "ciprofloxacino",
        "genericName": "Ciprofloxacino",
        "brand": "Genérico",
        "dosage": "500mg",
        "form": "Tableta",
        "description": "Antibiótico quinolónico de amplio espectro. Eficaz en infecciones urinarias y gastrointestinales.",
        "activeIngredients": ["Ciprofloxacino"],
    },
    # Antihipertensivos
    {
        "name": "Losartán",
        "nameLower": "losartan",
        "genericName": "Losartán potásico",
        "brand": "Genérico",
        "dosage": "50mg",
        "form": "Tableta",
        "description": "Antagonista de receptores de angiotensina II. Tratamiento de hipertensión arterial.",
        "activeIngredients": ["Losartán potásico"],
    },
    {
        "name": "Cozaar",
        "nameLower": "cozaar",
        "genericName": "Losartán potásico",
        "brand": "Merck",
        "dosage": "50mg",
        "form": "Tableta",
        "description": "Antihipertensivo de marca. Reduce la presión arterial y protege los riñones en diabéticos.",
        "activeIngredients": ["Losartán potásico"],
    },
    {
        "name": "Enalapril",
        "nameLower": "enalapril",
        "genericName": "Enalapril maleato",
        "brand": "Genérico",
        "dosage": "10mg",
        "form": "Tableta",
        "description": "Inhibidor de la ECA. Tratamiento de hipertensión y falla cardíaca congestiva.",
        "activeIngredients": ["Enalapril maleato"],
    },
    {
        "name": "Vasotec",
        "nameLower": "vasotec",
        "genericName": "Enalapril maleato",
        "brand": "Merck",
        "dosage": "10mg",
        "form": "Tableta",
        "description": "Antihipertensivo de marca tipo IECA. Controla la presión arterial alta.",
        "activeIngredients": ["Enalapril maleato"],
    },
    # Antidiabéticos
    {
        "name": "Metformina",
        "nameLower": "metformina",
        "genericName": "Metformina clorhidrato",
        "brand": "Genérico",
        "dosage": "850mg",
        "form": "Tableta",
        "description": "Antidiabético oral de primera línea para diabetes tipo 2. Reduce la glucosa en sangre.",
        "activeIngredients": ["Metformina clorhidrato"],
    },
    {
        "name": "Glucophage",
        "nameLower": "glucophage",
        "genericName": "Metformina clorhidrato",
        "brand": "Merck",
        "dosage": "850mg",
        "form": "Tableta",
        "description": "Antidiabético de marca ampliamente utilizado en el tratamiento de diabetes tipo 2.",
        "activeIngredients": ["Metformina clorhidrato"],
    },
    # Antiácidos / Gastrointestinales
    {
        "name": "Omeprazol",
        "nameLower": "omeprazol",
        "genericName": "Omeprazol",
        "brand": "Genérico",
        "dosage": "20mg",
        "form": "Cápsula",
        "description": "Inhibidor de la bomba de protones. Trata úlceras gástricas, reflujo y gastritis.",
        "activeIngredients": ["Omeprazol"],
    },
    {
        "name": "Prilosec",
        "nameLower": "prilosec",
        "genericName": "Omeprazol",
        "brand": "AstraZeneca",
        "dosage": "20mg",
        "form": "Cápsula",
        "description": "Antiácido de marca tipo IBP. Alivia la acidez estomacal y el reflujo gastroesofágico.",
        "activeIngredients": ["Omeprazol"],
    },
    {
        "name": "Metoclopramida",
        "nameLower": "metoclopramida",
        "genericName": "Metoclopramida",
        "brand": "Genérico",
        "dosage": "10mg",
        "form": "Tableta",
        "description": "Procinético y antiemético. Controla náuseas, vómitos y facilita el vaciamiento gástrico.",
        "activeIngredients": ["Metoclopramida"],
    },
    # Antihistamínicos
    {
        "name": "Loratadina",
        "nameLower": "loratadina",
        "genericName": "Loratadina",
        "brand": "Genérico",
        "dosage": "10mg",
        "form": "Tableta",
        "description": "Antihistamínico de segunda generación. Trata rinitis alérgica y urticaria sin causar somnolencia.",
        "activeIngredients": ["Loratadina"],
    },
    {
        "name": "Claritin",
        "nameLower": "claritin",
        "genericName": "Loratadina",
        "brand": "Bayer",
        "dosage": "10mg",
        "form": "Tableta",
        "description": "Antihistamínico de marca. Alivia síntomas de alergia como estornudos, picazón y ojos llorosos.",
        "activeIngredients": ["Loratadina"],
    },
    # Antidepresivos
    {
        "name": "Sertralina",
        "nameLower": "sertralina",
        "genericName": "Sertralina clorhidrato",
        "brand": "Genérico",
        "dosage": "50mg",
        "form": "Tableta",
        "description": "Antidepresivo ISRS. Trata depresión, trastorno de pánico, TOC y ansiedad social.",
        "activeIngredients": ["Sertralina clorhidrato"],
    },
    {
        "name": "Zoloft",
        "nameLower": "zoloft",
        "genericName": "Sertralina clorhidrato",
        "brand": "Pfizer",
        "dosage": "50mg",
        "form": "Tableta",
        "description": "Antidepresivo de marca tipo ISRS. Tratamiento de depresión y trastornos de ansiedad.",
        "activeIngredients": ["Sertralina clorhidrato"],
    },
    # Antiparasitarios
    {
        "name": "Albendazol",
        "nameLower": "albendazol",
        "genericName": "Albendazol",
        "brand": "Genérico",
        "dosage": "400mg",
        "form": "Tableta",
        "description": "Antiparasitario de amplio espectro. Trata infecciones por gusanos intestinales.",
        "activeIngredients": ["Albendazol"],
    },
    {
        "name": "Zentel",
        "nameLower": "zentel",
        "genericName": "Albendazol",
        "brand": "GlaxoSmithKline",
        "dosage": "400mg",
        "form": "Tableta",
        "description": "Antiparasitario de marca. Elimina parásitos intestinales como oxiuros y áscaris.",
        "activeIngredients": ["Albendazol"],
    },
]

# ─── Subir a Firestore ────────────────────────────────────────────────────────
def seed():
    collection = db.collection("medications")
    total = len(medications)

    print(f"\n🚀 Subiendo {total} medicamentos a Firestore...\n")

    for i, med in enumerate(medications, 1):
        doc_ref = collection.document()
        doc_ref.set(med)
        print(f"  [{i}/{total}] ✅ {med['name']} ({med['dosage']} - {med['form']})")

    print(f"\n✅ Seed completado. {total} medicamentos cargados en la colección 'medications'.")

if __name__ == "__main__":
    seed()
