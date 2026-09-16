import os
import pymupdf as fitz

DOCS_DIR = r"c:\xampp\tomcat\webapps\inmobiliaria\docs"
os.makedirs(DOCS_DIR, exist_ok=True)

# -------------------------------------------------------------
# HELPER DE DIBUJADO DE PÁGINAS PDF CON ESTILO INSTITUCIONAL UTS
# -------------------------------------------------------------
def crear_pagina_con_encabezado(doc, titulo, subtitulo):
    page = doc.new_page(width=612, height=792) # Carta estándar
    # Barra superior institucional
    page.draw_rect(fitz.Rect(0, 0, 612, 54), color=None, fill=(0.06, 0.30, 0.36)) # Color primario #0F4C5C
    page.insert_text(fitz.Point(36, 24), "UNIDADES TECNOLÓGICAS DE SANTANDER - UTS", fontsize=11, fontname="helv", color=(1, 1, 1))
    page.insert_text(fitz.Point(36, 42), "TECNOLOGÍA EN DESARROLLO DE SISTEMAS / PROGRAMACIÓN JAVA", fontsize=8, fontname="helv", color=(0.85, 0.90, 0.92))
    
    # Encabezado del documento
    page.insert_text(fitz.Point(36, 80), titulo, fontsize=15, fontname="hebo", color=(0.06, 0.30, 0.36))
    page.insert_text(fitz.Point(36, 96), subtitulo, fontsize=9, fontname="helv", color=(0.36, 0.40, 0.46))
    page.draw_line(fitz.Point(36, 104), fitz.Point(576, 104), color=(0.88, 0.90, 0.92), width=1)
    
    # Pie de página
    page.draw_line(fitz.Point(36, 755), fitz.Point(576, 755), color=(0.88, 0.90, 0.92), width=0.5)
    page.insert_text(fitz.Point(36, 768), "Docente: Julián Barney Jaimes Rincón | Nexus Living Co - Parcial Práctico Java", fontsize=8, fontname="helv", color=(0.5, 0.5, 0.5))
    page.insert_text(fitz.Point(520, 768), f"Pág. {len(doc)}", fontsize=8, fontname="helv", color=(0.5, 0.5, 0.5))
    return page

# -------------------------------------------------------------
# 1. GENERAR MER.pdf
# -------------------------------------------------------------
def generar_mer_pdf():
    doc = fitz.open()
    page1 = crear_pagina_con_encabezado(doc, "MODELO ENTIDAD - RELACIÓN (MER)", "Arquitectura conceptual de datos del sistema inmobiliario")
    
    y = 120
    texto_intro = (
        "El Modelo Entidad-Relación de Nexus Living Co ha sido diseñado para soportar la gestión inmobiliaria "
        "completa, garantizando la separación de responsabilidades y los tres tipos de cardinalidad requeridos por el parcial:\n"
        "• Relación 1:1: usuarios (credenciales y estado) y perfiles (datos personales).\n"
        "• Relación 1:N: agentes publican propiedades, propiedades contienen múltiples imágenes, solicitudes tienen documentos adjuntos.\n"
        "• Relación N:M: usuarios poseen roles (usuarios_roles), propiedades poseen amenidades (propiedades_caracteristicas) y favoritos.\n"
        "• Restricciones UNIQUE: usuario.correo, propiedad.matricula_inmobiliaria, perfiles.documento, citas(id_propiedad, fecha_hora)."
    )
    rect_intro = fitz.Rect(36, y, 576, y + 80)
    page1.insert_textbox(rect_intro, texto_intro, fontsize=8.5, fontname="helv", color=(0.15, 0.20, 0.25))
    
    # Insertar imagen del diagrama MER
    img_path = os.path.join(DOCS_DIR, "diagramas", "MER.png")
    if os.path.exists(img_path):
        rect_img = fitz.Rect(36, 210, 576, 730)
        page1.insert_image(rect_img, filename=img_path, keep_proportion=True)
    
    # Segunda página con matriz de entidades y cardinalidades
    page2 = crear_pagina_con_encabezado(doc, "MER - CARDINALIDADES Y REGLAS DE ASOCIACIÓN", "Detalle técnico de entidades y cardinalidades")
    
    detalle_cardinalidades = (
        "1. RELACIÓN UNO A UNO (1:1)\n"
        "   • Entidades: USUARIO (1) <----> (1) PERFIL\n"
        "   • Llave Primaria / Foránea: perfiles.id_usuario es simultáneamente PK y FK referenciando a usuarios(id).\n"
        "   • Regla: Se garantiza que un usuario posea exactamente un solo perfil de datos personales (nombres, documento, etc.),\n"
        "     manteniendo la tabla 'usuarios' ligera únicamente con credenciales de autenticación y estado.\n\n"
        "2. RELACIONES UNO A MUCHOS (1:N)\n"
        "   • INMOBILIARIA / AGENTE (1) ----> (N) PROPIEDADES (FK: propiedades.id_agente -> usuarios.id)\n"
        "   • PROPIEDAD (1) ----> (N) IMAGENES_PROPIEDADES (FK: imagenes_propiedades.id_propiedad -> propiedades.id)\n"
        "   • CLIENTE (1) ----> (N) CITAS (FK: citas.id_cliente -> usuarios.id)\n"
        "   • PROPIEDAD (1) ----> (N) CITAS (FK: citas.id_propiedad -> propiedades.id)\n"
        "   • CLIENTE (1) ----> (N) SOLICITUDES (FK: solicitudes.id_cliente -> usuarios.id)\n"
        "   • SOLICITUD (1) ----> (N) DOCUMENTOS_SOLICITUDES (FK: documentos_solicitudes.id_solicitud -> solicitudes.id)\n"
        "   • CIUDAD (1) ----> (N) PROPIEDADES (FK: propiedades.id_ciudad -> ciudades.id)\n"
        "   • TIPO_PROPIEDAD (1) ----> (N) PROPIEDADES (FK: propiedades.id_tipo -> tipos_propiedades.id)\n\n"
        "3. RELACIONES MUCHOS A MUCHOS (N:M)\n"
        "   • USUARIOS (N) <====> (M) ROLES mediante tabla asociativa 'usuarios_roles' (PK compuesta: id_usuario, id_rol).\n"
        "   • PROPIEDADES (N) <====> (M) CARACTERISTICAS mediante tabla asociativa 'propiedades_caracteristicas'.\n"
        "   • USUARIOS (N) <====> (M) PROPIEDADES mediante tabla asociativa 'favoritos' (PK compuesta: id_usuario, id_propiedad).\n\n"
        "4. ACCIONES REFERENCIALES (INTEGRIDAD REFERENCIAL)\n"
        "   • ON DELETE CASCADE: aplicado en imágenes, características intermedias, citas, solicitudes y documentos adjuntos.\n"
        "   • ON DELETE RESTRICT / ON UPDATE CASCADE: aplicado en ciudades y tipos para proteger la integridad del catálogo.\n"
        "   • ON DELETE SET NULL: aplicado en auditoría para conservar la trazabilidad histórica de eventos ante baja de usuarios."
    )
    page2.insert_textbox(fitz.Rect(36, 120, 576, 730), detalle_cardinalidades, fontsize=9, fontname="helv", color=(0.15, 0.20, 0.25))

    pdf_out = os.path.join(DOCS_DIR, "MER.pdf")
    doc.save(pdf_out)
    doc.close()
    print("Generado:", pdf_out)

# -------------------------------------------------------------
# 2. GENERAR Modelo_Relacional.pdf
# -------------------------------------------------------------
def generar_modelo_relacional_pdf():
    doc = fitz.open()
    page1 = crear_pagina_con_encabezado(doc, "MODELO RELACIONAL (ESQUEMA DE TABLAS)", "Especificación física de tablas, claves primarias, foráneas y restricciones UNIQUE")
    
    contenido_relacional = (
        "El esquema relacional implementado en MySQL 8.0 se compone de 14 tablas normalizadas en 3FN:\n\n"
        "1. roles (\n"
        "     id INT AUTO_INCREMENT [PK],\n"
        "     nombre VARCHAR(50) NOT NULL [UNIQUE]\n"
        "   )\n\n"
        "2. ciudades (\n"
        "     id INT AUTO_INCREMENT [PK],\n"
        "     nombre VARCHAR(100) NOT NULL [UNIQUE]\n"
        "   )\n\n"
        "3. tipos_propiedades (\n"
        "     id INT AUTO_INCREMENT [PK],\n"
        "     nombre VARCHAR(50) NOT NULL [UNIQUE]\n"
        "   )\n\n"
        "4. caracteristicas (\n"
        "     id INT AUTO_INCREMENT [PK],\n"
        "     nombre VARCHAR(100) NOT NULL [UNIQUE]\n"
        "   )\n\n"
        "5. usuarios (\n"
        "     id INT AUTO_INCREMENT [PK],\n"
        "     correo VARCHAR(150) NOT NULL [UNIQUE],\n"
        "     password_hash VARCHAR(64) NOT NULL,\n"
        "     password_salt VARCHAR(32) NOT NULL,\n"
        "     estado VARCHAR(20) NOT NULL DEFAULT 'activo'\n"
        "   )\n\n"
        "6. perfiles [Relación 1:1 con usuarios] (\n"
        "     id_usuario INT [PK, FK -> usuarios.id ON DELETE CASCADE],\n"
        "     nombres VARCHAR(100) NOT NULL,\n"
        "     apellidos VARCHAR(100) NOT NULL,\n"
        "     documento VARCHAR(20) NOT NULL [UNIQUE],\n"
        "     telefono VARCHAR(20),\n"
        "     direccion VARCHAR(200),\n"
        "     foto VARCHAR(255)\n"
        "   )\n\n"
        "7. usuarios_roles [Relación N:M entre usuarios y roles] (\n"
        "     id_usuario INT [PK, FK -> usuarios.id ON DELETE CASCADE],\n"
        "     id_rol INT [PK, FK -> roles.id ON DELETE CASCADE]\n"
        "   )"
    )
    page1.insert_textbox(fitz.Rect(36, 115, 576, 730), contenido_relacional, fontsize=9, fontname="helv", color=(0.15, 0.20, 0.25))

    page2 = crear_pagina_con_encabezado(doc, "MODELO RELACIONAL (PARTE 2)", "Tablas de catálogo inmobiliario, transacciones y auditoría")
    
    contenido_relacional_p2 = (
        "8. propiedades [Relación 1:N con agentes, ciudades y tipos] (\n"
        "     id INT AUTO_INCREMENT [PK],\n"
        "     titulo VARCHAR(150) NOT NULL,\n"
        "     descripcion TEXT,\n"
        "     direccion VARCHAR(200) NOT NULL,\n"
        "     precio DECIMAL(12,2) NOT NULL,\n"
        "     matricula_inmobiliaria VARCHAR(50) NOT NULL [UNIQUE],\n"
        "     id_ciudad INT NOT NULL [FK -> ciudades.id ON DELETE RESTRICT ON UPDATE CASCADE],\n"
        "     id_tipo INT NOT NULL [FK -> tipos_propiedades.id ON DELETE RESTRICT ON UPDATE CASCADE],\n"
        "     id_agente INT NOT NULL [FK -> usuarios.id ON DELETE RESTRICT ON UPDATE CASCADE],\n"
        "     estado VARCHAR(20) NOT NULL DEFAULT 'disponible', -- disponible, arrendado, vendido, inactivo\n"
        "     fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP\n"
        "   )\n\n"
        "9. imagenes_propiedades [Relación 1:N con propiedades] (\n"
        "     id INT AUTO_INCREMENT [PK],\n"
        "     id_propiedad INT NOT NULL [FK -> propiedades.id ON DELETE CASCADE],\n"
        "     url_imagen VARCHAR(255) NOT NULL\n"
        "   )\n\n"
        "10. propiedades_caracteristicas [Relación N:M propiedades <-> características] (\n"
        "      id_propiedad INT NOT NULL [PK, FK -> propiedades.id ON DELETE CASCADE],\n"
        "      id_caracteristica INT NOT NULL [PK, FK -> caracteristicas.id ON DELETE CASCADE]\n"
        "    )\n\n"
        "11. citas [Relación 1:N con clientes y propiedades] (\n"
        "      id INT AUTO_INCREMENT [PK],\n"
        "      id_propiedad INT NOT NULL [FK -> propiedades.id ON DELETE CASCADE],\n"
        "      id_cliente INT NOT NULL [FK -> usuarios.id ON DELETE CASCADE],\n"
        "      fecha_hora DATETIME NOT NULL,\n"
        "      estado VARCHAR(20) NOT NULL DEFAULT 'pendiente', -- pendiente, aceptada, cancelada\n"
        "      notas TEXT,\n"
        "      CONSTRAINT uq_cita_propiedad_horario UNIQUE (id_propiedad, fecha_hora)\n"
        "    )\n\n"
        "12. solicitudes [Relación 1:N con clientes y propiedades] (\n"
        "      id INT AUTO_INCREMENT [PK],\n"
        "      id_propiedad INT NOT NULL [FK -> propiedades.id ON DELETE CASCADE],\n"
        "      id_cliente INT NOT NULL [FK -> usuarios.id ON DELETE CASCADE],\n"
        "      tipo_solicitud VARCHAR(20) NOT NULL, -- compra, arriendo\n"
        "      estado VARCHAR(20) NOT NULL DEFAULT 'pendiente', -- pendiente, aprobada, rechazada\n"
        "      fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP\n"
        "    )\n\n"
        "13. documentos_solicitudes [Relación 1:N con solicitudes] (\n"
        "      id INT AUTO_INCREMENT [PK],\n"
        "      id_solicitud INT NOT NULL [FK -> solicitudes.id ON DELETE CASCADE],\n"
        "      nombre_archivo VARCHAR(150) NOT NULL,\n"
        "      ruta_archivo VARCHAR(255) NOT NULL,\n"
        "      tipo_documento VARCHAR(50) NOT NULL -- identificacion, ingresos, contrato, otro\n"
        "    )\n\n"
        "14. favoritos [Relación N:M usuarios <-> propiedades] (\n"
        "      id_usuario INT NOT NULL [PK, FK -> usuarios.id ON DELETE CASCADE],\n"
        "      id_propiedad INT NOT NULL [PK, FK -> propiedades.id ON DELETE CASCADE]\n"
        "    )\n\n"
        "15. auditoria (\n"
        "      id INT AUTO_INCREMENT [PK],\n"
        "      id_usuario INT [FK -> usuarios.id ON DELETE SET NULL],\n"
        "      accion VARCHAR(100) NOT NULL,\n"
        "      tabla_afectada VARCHAR(50),\n"
        "      registro_id INT,\n"
        "      fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,\n"
        "      detalles TEXT\n"
        "    )"
    )
    page2.insert_textbox(fitz.Rect(36, 115, 576, 730), contenido_relacional_p2, fontsize=8.2, fontname="helv", color=(0.15, 0.20, 0.25))

    pdf_out = os.path.join(DOCS_DIR, "Modelo_Relacional.pdf")
    doc.save(pdf_out)
    doc.close()
    print("Generado:", pdf_out)

# -------------------------------------------------------------
# 3. GENERAR Diccionario_Datos.pdf
# -------------------------------------------------------------
def generar_diccionario_datos_pdf():
    doc = fitz.open()
    
    tablas_diccionario = [
        ("usuarios", [
            ("id", "INT", "SÍ", "NO", "SÍ", "NO", "Identificador único autoincremental del usuario"),
            ("correo", "VARCHAR(150)", "NO", "NO", "SÍ", "NO", "Correo electrónico único (credencial de acceso)"),
            ("password_hash", "VARCHAR(64)", "NO", "NO", "NO", "NO", "Hash criptográfico SHA-256 de la contraseña"),
            ("password_salt", "VARCHAR(32)", "NO", "NO", "NO", "NO", "Salt aleatorio único generado por usuario"),
            ("estado", "VARCHAR(20)", "NO", "NO", "NO", "NO", "Estado de la cuenta ('activo', 'inactivo')")
        ]),
        ("perfiles", [
            ("id_usuario", "INT", "SÍ", "SÍ", "SÍ", "NO", "PK y FK hacia usuarios.id (Relación 1:1)"),
            ("nombres", "VARCHAR(100)", "NO", "NO", "NO", "NO", "Nombres del usuario"),
            ("apellidos", "VARCHAR(100)", "NO", "NO", "NO", "NO", "Apellidos del usuario"),
            ("documento", "VARCHAR(20)", "NO", "NO", "SÍ", "NO", "Cédula o documento de identidad único"),
            ("telefono", "VARCHAR(20)", "NO", "NO", "NO", "SÍ", "Número de contacto telefónico"),
            ("direccion", "VARCHAR(200)", "NO", "NO", "NO", "SÍ", "Dirección física de residencia"),
            ("foto", "VARCHAR(255)", "NO", "NO", "NO", "SÍ", "Ruta de fotografía de perfil")
        ]),
        ("propiedades", [
            ("id", "INT", "SÍ", "NO", "SÍ", "NO", "Identificador único del inmueble"),
            ("titulo", "VARCHAR(150)", "NO", "NO", "NO", "NO", "Título comercial de la publicación"),
            ("descripcion", "TEXT", "NO", "NO", "NO", "SÍ", "Descripción detallada del inmueble"),
            ("direccion", "VARCHAR(200)", "NO", "NO", "NO", "NO", "Ubicación física del inmueble"),
            ("precio", "DECIMAL(12,2)", "NO", "NO", "NO", "NO", "Precio de venta o canon de arriendo"),
            ("matricula_inmobiliaria", "VARCHAR(50)", "NO", "NO", "SÍ", "NO", "Número de matrícula inmobiliaria único"),
            ("id_ciudad", "INT", "NO", "SÍ", "NO", "NO", "FK hacia ciudades.id"),
            ("id_tipo", "INT", "NO", "SÍ", "NO", "NO", "FK hacia tipos_propiedades.id"),
            ("id_agente", "INT", "NO", "SÍ", "NO", "NO", "FK hacia usuarios.id (agente propietario)"),
            ("estado", "VARCHAR(20)", "NO", "NO", "NO", "NO", "Estado ('disponible','vendido','arrendado','inactivo')"),
            ("fecha_creacion", "TIMESTAMP", "NO", "NO", "NO", "NO", "Fecha y hora de registro en el sistema")
        ]),
        ("citas", [
            ("id", "INT", "SÍ", "NO", "SÍ", "NO", "Identificador de la cita"),
            ("id_propiedad", "INT", "NO", "SÍ", "COMP", "NO", "FK hacia propiedades.id"),
            ("id_cliente", "INT", "NO", "SÍ", "NO", "NO", "FK hacia usuarios.id (cliente solicitante)"),
            ("fecha_hora", "DATETIME", "NO", "NO", "COMP", "NO", "Fecha y hora agendada (UNIQUE con id_propiedad)"),
            ("estado", "VARCHAR(20)", "NO", "NO", "NO", "NO", "Estado ('pendiente','aceptada','cancelada')"),
            ("notas", "TEXT", "NO", "NO", "NO", "SÍ", "Observaciones del cliente o agente")
        ]),
        ("solicitudes", [
            ("id", "INT", "SÍ", "NO", "SÍ", "NO", "Identificador único del trámite"),
            ("id_propiedad", "INT", "NO", "SÍ", "NO", "NO", "FK hacia propiedades.id"),
            ("id_cliente", "INT", "NO", "SÍ", "NO", "NO", "FK hacia usuarios.id (cliente radicador)"),
            ("tipo_solicitud", "VARCHAR(20)", "NO", "NO", "NO", "NO", "Tipo de trámite ('compra', 'arriendo')"),
            ("estado", "VARCHAR(20)", "NO", "NO", "NO", "NO", "Estado ('pendiente','aprobada','rechazada')"),
            ("fecha_solicitud", "TIMESTAMP", "NO", "NO", "NO", "NO", "Fecha de radicación del trámite")
        ]),
        ("documentos_solicitudes", [
            ("id", "INT", "SÍ", "NO", "SÍ", "NO", "Identificador único del documento"),
            ("id_solicitud", "INT", "NO", "SÍ", "NO", "NO", "FK hacia solicitudes.id (Relación 1:N)"),
            ("nombre_archivo", "VARCHAR(150)", "NO", "NO", "NO", "NO", "Nombre original del archivo radicado"),
            ("ruta_archivo", "VARCHAR(255)", "NO", "NO", "NO", "NO", "Ruta de almacenamiento en servidor/URL"),
            ("tipo_documento", "VARCHAR(50)", "NO", "NO", "NO", "NO", "Tipo ('identificacion','ingresos','contrato','otro')")
        ])
    ]

    for nombre_tabla, campos in tablas_diccionario:
        page = crear_pagina_con_encabezado(doc, f"DICCIONARIO DE DATOS — TABLA: {nombre_tabla.upper()}", f"Estructura de campos, tipos, restricciones y propósito funcional")
        
        y = 120
        # Cabecera de la tabla
        page.draw_rect(fitz.Rect(36, y, 576, y + 20), color=None, fill=(0.06, 0.30, 0.36))
        page.insert_text(fitz.Point(42, y + 14), "Campo", fontsize=8.5, fontname="hebo", color=(1, 1, 1))
        page.insert_text(fitz.Point(125, y + 14), "Tipo", fontsize=8.5, fontname="hebo", color=(1, 1, 1))
        page.insert_text(fitz.Point(210, y + 14), "PK", fontsize=8.5, fontname="hebo", color=(1, 1, 1))
        page.insert_text(fitz.Point(235, y + 14), "FK", fontsize=8.5, fontname="hebo", color=(1, 1, 1))
        page.insert_text(fitz.Point(260, y + 14), "UNQ", fontsize=8.5, fontname="hebo", color=(1, 1, 1))
        page.insert_text(fitz.Point(295, y + 14), "NULL", fontsize=8.5, fontname="hebo", color=(1, 1, 1))
        page.insert_text(fitz.Point(335, y + 14), "Descripción", fontsize=8.5, fontname="hebo", color=(1, 1, 1))
        
        y += 20
        fill_alt = False
        for campo, tipo, pk, fk, unq, nulo, desc in campos:
            bg_color = (0.96, 0.97, 0.98) if fill_alt else (1, 1, 1)
            page.draw_rect(fitz.Rect(36, y, 576, y + 22), color=(0.88, 0.90, 0.92), fill=bg_color, width=0.5)
            page.insert_text(fitz.Point(42, y + 15), campo, fontsize=8, fontname="hebo", color=(0.1, 0.1, 0.1))
            page.insert_text(fitz.Point(125, y + 15), tipo, fontsize=8, fontname="helv", color=(0.2, 0.2, 0.2))
            page.insert_text(fitz.Point(210, y + 15), pk, fontsize=8, fontname="helv", color=(0.1, 0.5, 0.2) if pk=="SÍ" else (0.4, 0.4, 0.4))
            page.insert_text(fitz.Point(235, y + 15), fk, fontsize=8, fontname="helv", color=(0.1, 0.3, 0.6) if fk=="SÍ" else (0.4, 0.4, 0.4))
            page.insert_text(fitz.Point(260, y + 15), unq, fontsize=8, fontname="helv", color=(0.7, 0.3, 0.1) if unq in ["SÍ","COMP"] else (0.4, 0.4, 0.4))
            page.insert_text(fitz.Point(295, y + 15), nulo, fontsize=8, fontname="helv", color=(0.4, 0.4, 0.4))
            page.insert_text(fitz.Point(335, y + 15), desc[:52], fontsize=7.5, fontname="helv", color=(0.2, 0.2, 0.2))
            y += 22
            fill_alt = not fill_alt
            
        y += 25
        page.insert_text(fitz.Point(36, y), "Reglas de Integridad y Restricciones Aplicadas:", fontsize=10, fontname="hebo", color=(0.06, 0.30, 0.36))
        y += 18
        reglas_texto = (
            f"• Tabla '{nombre_tabla}' implementada bajo el motor InnoDB en MySQL.\n"
            "• Integridad de dominio garantizada mediante tipos de datos primitivos y longitud controlada.\n"
            "• Llaves foráneas con índices automáticos B-Tree para optimización de consultas INNER JOIN.\n"
            "• Sin redundancia ni atributos calculados almacenados (cumplimiento 3FN)."
        )
        page.insert_textbox(fitz.Rect(36, y, 576, y + 80), reglas_texto, fontsize=8.5, fontname="helv", color=(0.2, 0.25, 0.3))

    pdf_out = os.path.join(DOCS_DIR, "Diccionario_Datos.pdf")
    doc.save(pdf_out)
    doc.close()
    print("Generado:", pdf_out)

# -------------------------------------------------------------
# 4. GENERAR Normalizacion_3FN.pdf
# -------------------------------------------------------------
def generar_normalizacion_3fn_pdf():
    doc = fitz.open()
    page1 = crear_pagina_con_encabezado(doc, "PROCESO DE NORMALIZACIÓN (1FN, 2FN Y 3FN)", "Demostración rigurosa del cumplimiento de formas normales sobre el modelo")
    
    texto_norm = (
        "El modelo relacional de Nexus Living Co fue sometido a un proceso estricto de normalización para "
        "eliminar redundancias, inconsistencias en actualizaciones y anomalías de inserción y borrado.\n\n"
        "1. PRIMERA FORMA NORMAL (1FN): ATOMICIDAD Y ELIMINACIÓN DE GRUPOS REPETITIVOS\n"
        "   • Criterio: Todos los atributos son atómicos (no divisibles) y no existen grupos repetitivos o listas en una columna.\n"
        "   • Aplicación en el proyecto:\n"
        "     - Teléfonos y nombres: Se separaron en nombres, apellidos y teléfono singular.\n"
        "     - Múltiples fotos por propiedad: En lugar de campos 'foto1, foto2, foto3' o una lista separada por comas, "
        "se creó la tabla hija 'imagenes_propiedades' (1:N), cumpliendo la atomicidad.\n"
        "     - Múltiples amenidades por inmueble: En lugar de cadenas en texto plano, se creó el catálogo 'caracteristicas' "
        "y la tabla asociativa 'propiedades_caracteristicas' (N:M).\n"
        "     - Roles múltiples por usuario: Se descompuso en catálogo 'roles' y tabla 'usuarios_roles' (N:M).\n\n"
        "2. SEGUNDA FORMA NORMAL (2FN): DEPENDENCIA FUNCIONAL COMPLETA\n"
        "   • Criterio: Cumple 1FN y ningún atributo no clave depende parcialmente de una parte de la llave primaria compuesta.\n"
        "   • Aplicación en el proyecto:\n"
        "     - Tablas intermedias (usuarios_roles, propiedades_caracteristicas, favoritos): Poseen llave primaria compuesta "
        "(ej. id_usuario, id_rol). No contienen atributos descriptivos que dependan de uno solo de ellos. Todo dato descriptivo "
        "del usuario está en 'usuarios'/'perfiles' y del rol en 'roles'.\n"
        "     - Cada tabla con clave simple (propiedades, citas, solicitudes) depende al 100% de su identificador ID.\n\n"
        "3. TERCERA FORMA NORMAL (3FN): ELIMINACIÓN DE DEPENDENCIAS TRANSITIVAS\n"
        "   • Criterio: Cumple 2FN y ningún atributo no clave depende funcionalmente de otro atributo no clave (X -> Y -> Z).\n"
        "   • Aplicación en el proyecto:\n"
        "     - En 'propiedades', no se almacena el nombre de la ciudad ni el nombre del tipo de propiedad, únicamente "
        "sus claves foráneas 'id_ciudad' e 'id_tipo'. Si el nombre de una ciudad cambia, se actualiza en 'ciudades' "
        "sin generar inconsistencias en miles de propiedades.\n"
        "     - En 'usuarios', no se duplican los datos del perfil; se separaron en la relación 1:1 'perfiles' "
        "(id_usuario PK y FK), evitando transitividad entre credenciales y datos civiles.\n"
        "     - No existen atributos calculados almacenados (ej. cantidad de citas o estado financiero acumulado se calcula "
        "vía consultas SQL de agregación GROUP BY)."
    )
    page1.insert_textbox(fitz.Rect(36, 115, 576, 730), texto_norm, fontsize=8.6, fontname="helv", color=(0.15, 0.20, 0.25))

    pdf_out = os.path.join(DOCS_DIR, "Normalizacion_3FN.pdf")
    doc.save(pdf_out)
    doc.close()
    print("Generado:", pdf_out)

# -------------------------------------------------------------
# 5. GENERAR Consultas_SQL.pdf
# -------------------------------------------------------------
def generar_consultas_sql_pdf():
    doc = fitz.open()
    page1 = crear_pagina_con_encabezado(doc, "CONSULTAS SQL OBLIGATORIAS DEL PARCIAL", "Demostración técnica de las 5 consultas requeridas conectadas a la aplicación")
    
    consultas = [
        ("CONSULTA 1: INNER JOIN ENTRE CUATRO (4) TABLAS",
         "Propiedades detalladas con su ciudad, tipo y agente asignado:",
         "SELECT p.id, p.titulo, p.precio, c.nombre AS ciudad, t.nombre AS tipo, u.correo AS agente_correo\n"
         "FROM propiedades p\n"
         "INNER JOIN ciudades c ON p.id_ciudad = c.id\n"
         "INNER JOIN tipos_propiedades t ON p.id_tipo = t.id\n"
         "INNER JOIN usuarios u ON p.id_agente = u.id\n"
         "ORDER BY p.id DESC;\n",
         "Propósito: Generar el inventario consolidado para administración. Demuestra el cruce simultáneo de 4 tablas."),
        
        ("CONSULTA 2: INNER JOIN ENTRE CUATRO (4) TABLAS",
         "Detalle de citas vinculando propiedad, cliente y agente:",
         "SELECT ci.id, ci.fecha_hora, ci.estado, p.titulo AS propiedad_titulo,\n"
         "       CONCAT(per_cli.nombres, ' ', per_cli.apellidos) AS cliente_nombre,\n"
         "       CONCAT(per_age.nombres, ' ', per_age.apellidos) AS agente_nombre\n"
         "FROM citas ci\n"
         "INNER JOIN propiedades p ON ci.id_propiedad = p.id\n"
         "INNER JOIN perfiles per_cli ON ci.id_cliente = per_cli.id_usuario\n"
         "INNER JOIN perfiles per_age ON p.id_agente = per_age.id_usuario\n"
         "ORDER BY ci.fecha_hora DESC;\n",
         "Propósito: Visualizar la agenda global de visitas con nombres reales de clientes y agentes comerciales."),
        
        ("CONSULTA 3: RESOLUCIÓN DE RELACIÓN MUCHOS A MUCHOS (N:M)",
         "Características y amenidades asociadas a un inmueble:",
         "SELECT p.titulo, c.nombre AS caracteristica\n"
         "FROM propiedades p\n"
         "INNER JOIN propiedades_caracteristicas pc ON p.id = pc.id_propiedad\n"
         "INNER JOIN caracteristicas c ON pc.id_caracteristica = c.id\n"
         "WHERE p.id = ?;\n",
         "Propósito: Resolver la tabla intermedia asociativa propiedades_caracteristicas para renderizar etiquetas en la vista pública.")
    ]
    
    y = 115
    for tit, desc, sql, prop in consultas:
        page1.insert_text(fitz.Point(36, y), tit, fontsize=9.5, fontname="hebo", color=(0.06, 0.30, 0.36))
        y += 14
        page1.insert_text(fitz.Point(36, y), desc, fontsize=8, fontname="helv", color=(0.3, 0.3, 0.3))
        y += 8
        page1.draw_rect(fitz.Rect(36, y, 576, y + 58), color=None, fill=(0.95, 0.96, 0.97))
        page1.insert_textbox(fitz.Rect(42, y + 4, 570, y + 54), sql, fontsize=7.5, fontname="courier", color=(0.1, 0.1, 0.1))
        y += 64
        page1.insert_text(fitz.Point(36, y), f"• {prop}", fontsize=8, fontname="helv", color=(0.2, 0.4, 0.3))
        y += 24

    page2 = crear_pagina_con_encabezado(doc, "CONSULTAS SQL OBLIGATORIAS (PARTE 2)", "Consultas con LEFT JOIN y Agregación con GROUP BY / HAVING")
    
    consultas_p2 = [
        ("CONSULTA 4: CONSULTA CON LEFT JOIN (INMUEBLES SIN VISITAS)",
         "Identificación de propiedades activas sin ninguna cita agendada:",
         "SELECT p.id, p.titulo, p.precio, p.matricula_inmobiliaria\n"
         "FROM propiedades p\n"
         "LEFT JOIN citas c ON p.id = c.id_propiedad\n"
         "WHERE c.id IS NULL AND p.estado = 'disponible';\n",
         "Propósito de negocio: Detección de inventario estancado o sin tracción comercial para impulsar estrategias de marketing inmobiliario. "
         "Demuestra el uso de LEFT JOIN preservando tuplas de la izquierda sin coincidencia en la derecha."),
        
        ("CONSULTA 5: AGREGACIÓN CON GROUP BY Y CLÁUSULA HAVING",
         "Inmuebles y valor acumulado por ciudad con inventario relevante:",
         "SELECT c.nombre AS ciudad, COUNT(p.id) AS total_propiedades, SUM(p.precio) AS valor_acumulado\n"
         "FROM ciudades c\n"
         "INNER JOIN propiedades p ON c.id = p.id_ciudad\n"
         "WHERE p.estado = 'disponible'\n"
         "GROUP BY c.nombre\n"
         "HAVING COUNT(p.id) > 2;\n",
         "Propósito de negocio: Métricas de concentración de mercado. La cláusula HAVING filtra exclusivamente "
         "aquellas plazas donde la inmobiliaria tiene más de dos propiedades en oferta, calculando el valor patrimonial total.")
    ]
    
    y = 115
    for tit, desc, sql, prop in consultas_p2:
        page2.insert_text(fitz.Point(36, y), tit, fontsize=9.5, fontname="hebo", color=(0.06, 0.30, 0.36))
        y += 14
        page2.insert_text(fitz.Point(36, y), desc, fontsize=8, fontname="helv", color=(0.3, 0.3, 0.3))
        y += 8
        page2.draw_rect(fitz.Rect(36, y, 576, y + 58), color=None, fill=(0.95, 0.96, 0.97))
        page2.insert_textbox(fitz.Rect(42, y + 4, 570, y + 54), sql, fontsize=7.5, fontname="courier", color=(0.1, 0.1, 0.1))
        y += 64
        page2.insert_textbox(fitz.Rect(36, y, 576, y + 35), f"• {prop}", fontsize=8, fontname="helv", color=(0.2, 0.4, 0.3))
        y += 45

    pdf_out = os.path.join(DOCS_DIR, "Consultas_SQL.pdf")
    doc.save(pdf_out)
    doc.close()
    print("Generado:", pdf_out)

# -------------------------------------------------------------
# 6. GENERAR Casos_de_Uso.pdf
# -------------------------------------------------------------
def generar_casos_uso_pdf():
    doc = fitz.open()
    page1 = crear_pagina_con_encabezado(doc, "ESPECIFICACIÓN DE CASOS DE USO (PARTE 1)", "Actores, matriz de casos de uso y catálogo público / autenticación")
    
    texto_p1 = (
        "1. ACTORES DEL SISTEMA\n"
        "   • Visitante: Usuario no autenticado. Navega catálogo, filtra inmuebles y accede a registro.\n"
        "   • Cliente: Usuario autenticado. Gestiona perfil 1:1, favoritos N:M, agenda citas y radica solicitudes con documentos.\n"
        "   • Inmobiliaria (Agente): Usuario comercial. Publica/edita/inactiva propiedades, gestiona imágenes 1:N y características N:M,\n"
        "     atiende visitas y revisa/aprueba/rechaza solicitudes con documentos.\n"
        "   • Administrador: Control total. Parametriza usuarios, asigna roles, consulta auditoría y reportes analíticos.\n\n"
        "2. CASOS DE USO — CATÁLOGO PÚBLICO Y AUTENTICACIÓN\n\n"
        "   [CU-01] Búsqueda y Filtrado de Propiedades\n"
        "   • Actor: Visitante / Cliente | Objetivo: Encontrar inmuebles por ciudad, tipo y rango de precio.\n"
        "   • Precondiciones: Propiedades en estado 'disponible'.\n"
        "   • Flujo Principal: El actor selecciona filtros en /buscar -> PropiedadDAO ejecuta consulta dinámica preparada\n"
        "     -> se despliega la cuadrícula con fotos, precios formateados y ubicación.\n"
        "   • Flujo Alternativo: Si no hay coincidencias, mensaje informativo sin romper la navegación.\n\n"
        "   [CU-03] Registro de Usuario Cliente con Restricción UNIQUE\n"
        "   • Actor: Visitante | Objetivo: Crear cuenta de cliente.\n"
        "   • Precondiciones: Correo y documento de identidad no registrados previamente.\n"
        "   • Flujo Principal: Diligencia formulario en /registro.jsp -> validación de formatos en ValidadorUtil -> generación de salt\n"
        "     y hash SHA-256 (HashUtil) -> transacción atómica en usuarios, perfiles (1:1) y usuarios_roles (rol Cliente) -> redirección a login.\n"
        "   • Flujo Alternativo: Ante correo o documento duplicado (MySQL 1062), captura amigable: 'El correo electrónico ya se encuentra registrado'.\n\n"
        "   [CU-04] Inicio y Cierre de Sesión Seguro\n"
        "   • Actor: Usuario Registrado | Objetivo: Acceder al dashboard según rol asignado.\n"
        "   • Flujo Principal: Ingreso de credenciales en /login.jsp -> validación de hash+salt en BD -> creación de HttpSession con usuario,\n"
        "     perfil y roles -> redirección automática: Admin (/dashboard_admin.jsp), Agente (/dashboard_agente.jsp), Cliente (/dashboard_cliente.jsp).\n"
        "   • Cierre: Enlace /logout invalida la sesión completamente (session.invalidate())."
    )
    page1.insert_textbox(fitz.Rect(36, 115, 576, 730), texto_p1, fontsize=8.2, fontname="helv", color=(0.15, 0.20, 0.25))

    page2 = crear_pagina_con_encabezado(doc, "ESPECIFICACIÓN DE CASOS DE USO (PARTE 2)", "Operaciones inmobiliarias, citas, solicitudes y reportes")
    
    texto_p2 = (
        "3. CASOS DE USO — PROPIEDADES, CITAS, SOLICITUDES Y ADMINISTRACIÓN\n\n"
        "   [CU-06] Marcado de Favoritos (N:M)\n"
        "   • Actor: Cliente | Objetivo: Guardar inmuebles de interés.\n"
        "   • Flujo: Clic en icono de corazón -> PropiedadController (/favoritos/toggle) inserta o retira la tupla (id_usuario, id_propiedad)\n"
        "     en la tabla asociativa favoritos -> visible en /dashboard_cliente.jsp.\n\n"
        "   [CU-07] Agendamiento de Citas con Restricción UNIQUE de Horario\n"
        "   • Actor: Cliente | Objetivo: Solicitar visita presencial a un inmueble.\n"
        "   • Flujo Principal: Selecciona fecha futura y hora en /cita_form.jsp -> verificación de fecha válida -> CitaDAO inserta en citas (estado 'pendiente').\n"
        "   • Flujo Alternativo: Si ya existe visita en esa propiedad y hora (UNIQUE id_propiedad, fecha_hora), se emite mensaje claro:\n"
        "     'Ya existe una cita agendada para esta propiedad en el mismo horario. Por favor selecciona otra hora'.\n\n"
        "   [CU-08] Radicación de Solicitud con Documentos Adjuntos (1:N)\n"
        "   • Actor: Cliente | Objetivo: Tramitar compra o arriendo adjuntando comprobantes.\n"
        "   • Flujo: Selecciona tipo (compra/arriendo) y registra rutas de soportes (cédula, ingresos, contrato) -> SolicitudDAO inserta en solicitudes\n"
        "     y documentos_solicitudes (1:N) -> visible en panel de cliente y bandeja del agente.\n\n"
        "   [CU-09 y CU-11] Publicación y Baja Lógica de Inmuebles\n"
        "   • Actor: Inmobiliaria (Agente) | Objetivo: Gestionar catálogo propio.\n"
        "   • Publicación: Transacción atómica en propiedades, imagenes_propiedades (1:N) y propiedades_caracteristicas (N:M) con matrícula UNIQUE.\n"
        "   • Baja Lógica: Acción 'Dar de baja' ejecuta UPDATE propiedades SET estado = 'inactivo' WHERE id = ?, retirándolo del catálogo público\n"
        "     sin romper integridad referencial con citas ni transacciones pasadas.\n\n"
        "   [CU-13] Revisión de Documentación y Aprobación/Rechazo de Solicitud\n"
        "   • Actor: Inmobiliaria (Agente) | Objetivo: Dictaminar solicitudes recibidas.\n"
        "   • Flujo: Agente revisa los documentos adjuntos en /agente/solicitudes -> Clic en 'Aprobar' -> solicitud pasa a 'aprobada' y automáticamente\n"
        "     el estado de la propiedad cambia a 'vendido' (si compra) o 'arrendado' (si arriendo), previniendo ventas duplicadas.\n\n"
        "   [CU-15] Reportes SQL y Auditoría del Sistema\n"
        "   • Actor: Administrador | Objetivo: Toma de decisiones basada en datos consolidados.\n"
        "   • Flujo: Consulta en /admin/reportes de las 5 consultas requeridas (INNER JOIN x4, N:M, LEFT JOIN, GROUP BY + HAVING)\n"
        "     y trazabilidad de eventos del sistema en /admin/auditoria."
    )
    page2.insert_textbox(fitz.Rect(36, 115, 576, 730), texto_p2, fontsize=8.2, fontname="helv", color=(0.15, 0.20, 0.25))

    pdf_out = os.path.join(DOCS_DIR, "Casos_de_Uso.pdf")
    doc.save(pdf_out)
    doc.close()
    print("Generado:", pdf_out)

if __name__ == "__main__":
    generar_mer_pdf()
    generar_modelo_relacional_pdf()
    generar_diccionario_datos_pdf()
    generar_normalizacion_3fn_pdf()
    generar_consultas_sql_pdf()
    generar_casos_uso_pdf()
    print("TODOS LOS DOCUMENTOS PDF GENERADOS CON ÉXITO.")
