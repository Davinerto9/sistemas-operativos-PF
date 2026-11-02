# Data Center Manager

Herramientas de administración de sistemas diseñadas para facilitar las labores de supervisión y mantenimiento de un Data Center mediante scripts de **PowerShell** y **Bash**.

## **Integrantes:**

* Alejandro Vargas Sánchez - A00404840
* Catalina Bernal - A00399113
* David Chicué Romero - A00405613

## Descripción del proyecto

Data Center Manager es un proyecto desarrollado para la asignatura de Sistemas Operacionales de la Universidad Icesi. Su objetivo es proporcionar un conjunto de herramientas que permitan a los administradores de un Data Center consultar información del sistema operativo, supervisar los recursos disponibles y realizar copias de seguridad.

El proyecto contempla dos implementaciones independientes:

* **PowerShell:** herramienta para sistemas Windows.
* **Bash:** herramienta para sistemas Linux.

Ambas aplicaciones disponen de un menú interactivo desde el cual el administrador puede acceder a las diferentes funcionalidades.

## Funcionalidades

El proyecto contempla cinco funcionalidades principales:

### 1. Gestión de usuarios

Permite consultar los usuarios registrados en el sistema y visualizar la fecha y hora de su último inicio de sesión (*login*).

### 2. Información de discos y filesystems

Permite consultar los discos y sistemas de archivos conectados al equipo, mostrando:

* Identificador o nombre del disco.
* Sistema de archivos.
* Tamaño total en bytes.
* Espacio libre en bytes.

### 3. Búsqueda de archivos más grandes

Permite especificar un disco o filesystem para identificar los diez archivos de mayor tamaño almacenados en él.

Para cada archivo se presenta:

* Nombre del archivo.
* Tamaño en bytes.
* Ruta completa del archivo.

### 4. Supervisión de memoria

Permite consultar información relacionada con la memoria del sistema:

* Memoria RAM libre en bytes y porcentaje.
* Espacio de SWAP utilizado en bytes y porcentaje.

### 5. Copias de seguridad (Backup)

Permite realizar copias de seguridad de un directorio especificado hacia una memoria USB.

Además de copiar los archivos, se genera un catálogo que contiene:

* Nombre del archivo.
* Fecha de última modificación.
* Ruta del archivo.

## Arquitectura del proyecto

El proyecto utiliza una arquitectura modular, separando las funcionalidades en archivos independientes para facilitar su desarrollo, mantenimiento y pruebas.

### PowerShell

```text
DataCenterManager/
│
├── main.ps1
│
├── modules/
│   ├── Users.ps1
│   ├── Disks.ps1
│   ├── LargeFiles.ps1
│   ├── Memory.ps1
│   └── Backup.ps1
│
├── utils/
│   ├── Menu.ps1
│   ├── Logger.ps1
│   └── Helpers.ps1
│
├── backups/
│
└── README.md
```

| Archivo          | Descripción                                                                         |
| ---------------- | ----------------------------------------------------------------------------------- |
| `main.ps1`       | Punto de entrada de la aplicación. Importa los módulos y ejecuta el menú principal. |
| `Users.ps1`      | Consulta los usuarios del sistema y su último inicio de sesión.                     |
| `Disks.ps1`      | Obtiene información de los discos y filesystems.                                    |
| `LargeFiles.ps1` | Identifica los diez archivos más grandes de una ruta especificada.                  |
| `Memory.ps1`     | Consulta la memoria RAM y el espacio de SWAP.                                       |
| `Backup.ps1`     | Gestiona las copias de seguridad y la generación de catálogos.                      |
| `Menu.ps1`       | Gestiona la interacción con el usuario.                                             |
| `Logger.ps1`     | Registra operaciones y errores.                                                     |
| `Helpers.ps1`    | Contiene funciones auxiliares reutilizables.                                        |

### Bash

La implementación en Bash seguirá una organización equivalente, adaptada a las herramientas y características de los sistemas Linux.

*La estructura definitiva de esta implementación se documentará durante su desarrollo.*

## Instalación y ejecución

### PowerShell

1. Acceder al directorio del proyecto:

```powershell
cd Powershell
```

2. Ejecutar la aplicación:

```powershell
.\main.ps1
```

Si la política de ejecución de PowerShell impide ejecutar scripts, puedes habilitar la ejecución únicamente para la sesión actual:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

1. Seleccionar la funcionalidad deseada desde el menú principal.

### Bash

1. Acceder al directorio del proyecto:

```bash
cd Unix
```

2. Otorgar permisos de ejecución al script principal:

```bash
chmod +x main.sh
```

3. Ejecutar la aplicación:

```bash
./main.sh
```
