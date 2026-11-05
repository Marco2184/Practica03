# Laboratorio Calificado 3 — CRUD Docente con SwiftData

Proyecto iOS nativo con SwiftUI y SwiftData basado en el proyecto proporcionado por el profesor.

## Cómo ejecutar

1. Descomprimir el ZIP en macOS.
2. Abrir `apple_lab12_pract03_SwiftData.xcodeproj` con Xcode.
3. Seleccionar un simulador de iPhone (preferentemente iPhone 16 o similar, iOS 18.2 o superior).
4. Ejecutar con **⌘R**.

**Requisitos:** Xcode con SDK iOS 18.2 o superior. La aplicación usa almacenamiento local SwiftData, sin servidor ni Internet.

## Funciones solicitadas

- **Pantalla principal:** título `Teachers`, icono `+` y campo `Search teachers...`.
- **Crear:** pulsar `+`, llenar `PERSONAL INFORMATION` y `PROFESSIONAL INFORMATION`, pulsar `Save`.
- **Listar:** al guardar se muestra nombre, especialidad azul y correo gris.
- **Buscar:** escribir nombre, apellido, especialidad o correo; filtra al instante. La `×` limpia la búsqueda.
- **Editar:** pulsar una fila, cambiar campos y pulsar `Save`.
- **Eliminar:** deslizar una fila hacia la izquierda y pulsar `Delete`; también existe `Delete Teacher` en la pantalla de edición. Se solicita confirmación.
- **Persistencia:** los cambios permanecen al cerrar y volver a abrir la aplicación.

## Datos para reproducir las capturas

El inicio está **vacío**, tal como la primera captura. Crear manualmente estos dos docentes para reproducir las pantallas de listado y búsqueda:

| Campo | Docente 1 | Docente 2 |
|---|---|---|
| First Name | Jaime | Juan |
| Last Name | Gomez | Leon |
| Email | jgomezm@tecsup.edu.pe | jleon@tecsup.edu.pe |
| Phone | 945784125 | 945784126 |
| Date of Birth | 1 Aug 2022 | 1 Aug 2022 |
| Specialty | Java Senior | IOS Developer |
| Hire Date | 1 Jun 2025 | 1 Jun 2025 |
| Active | Sí | Sí |

Buscar `Gomez` para obtener la captura de filtro. Al deslizar la fila hacia la izquierda aparece `Delete`, igual que en la referencia.

## Estructura

- `apple_lab12_pract03_SwiftData/Item.swift`: modelo `Teacher` (@Model).
- `apple_lab12_pract03_SwiftData/ContentView.swift`: listado, búsqueda, formulario de creación/edición y eliminación.
- `apple_lab12_pract03_SwiftData/apple_lab12_pract03_SwiftDataApp.swift`: configuración del contenedor SwiftData.
- `images/`: imágenes originales de referencia del profesor.

**Nota:** Las vistas están desarrolladas con componentes nativos de SwiftUI y respetan el diseño, la distribución, los rótulos y el flujo de las referencias. La apariencia de los controles puede variar ligeramente según la versión de iOS y el tamaño del dispositivo.
