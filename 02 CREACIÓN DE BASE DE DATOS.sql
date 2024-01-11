-- Tipo de documento
CREATE TABLE TiposDocumento (
    tipo_documento_id SERIAL PRIMARY KEY,
    nombre_tipo_documento VARCHAR(50) NOT NULL
);

INSERT INTO TiposDocumento (nombre_tipo_documento) VALUES
    ('DNI'),
    ('Pasaporte'),
    ('Licencia de conducir');

-- Tabla de Nacionalidades
CREATE TABLE Nacionalidades (
    nacionalidad_id SERIAL PRIMARY KEY,
    nombre_nacionalidad VARCHAR(50) NOT NULL
);

INSERT INTO Nacionalidades (nombre_nacionalidad) VALUES
    ('Mexicana'),
    ('Estadounidense'),
    ('Española');

-- Tabla de modalidades de impartición
CREATE TABLE ModalidadesImparticion (
    modalidad_id SERIAL PRIMARY KEY,
    nombre_modalidad VARCHAR(50) NOT NULL
);

INSERT INTO ModalidadesImparticion (nombre_modalidad) VALUES
    ('Presencial'),
    ('Virtual'),
    ('Semipresencial');

-- Tabla de cursos
CREATE TABLE Cursos (
    curso_id SERIAL PRIMARY KEY,
    nombre_curso VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    duracion_meses INT NOT NULL,
    modalidad_id INT NOT NULL,
    FOREIGN KEY (modalidad_id) REFERENCES ModalidadesImparticion(modalidad_id)
);

INSERT INTO Cursos (nombre_curso, descripcion, duracion_meses, modalidad_id) VALUES
    ('Curso de programación', 'Aprende a programar desde cero', 6, 1),
    ('Curso de diseño gráfico', 'Diseño creativo y moderno', 4, 2),
    ('Curso de marketing digital', 'Estrategias efectivas en línea', 8, 3);

-- Tabla de Alumnos
CREATE TABLE Alumnos (
    alumno_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    tipo_documento_id INT NOT NULL,
    numero_documento VARCHAR(20) NOT NULL UNIQUE,
    fecha_nacimiento DATE NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    correo_electronico VARCHAR(50) NOT NULL UNIQUE,
    nacionalidad_id INT NOT NULL,
    curso_id INT NOT NULL,
    FOREIGN KEY (tipo_documento_id) REFERENCES TiposDocumento(tipo_documento_id),
    FOREIGN KEY (nacionalidad_id) REFERENCES Nacionalidades(nacionalidad_id),
    FOREIGN KEY (curso_id) REFERENCES Cursos(curso_id)
);

INSERT INTO Alumnos (nombre, apellido, tipo_documento_id, numero_documento, fecha_nacimiento, direccion, telefono, correo_electronico, nacionalidad_id, curso_id) VALUES
    ('Juan', 'Pérez', 1, '12345678', '1990-05-15', 'Calle A, 123', '555-1234', 'juan@example.com', 1, 1),
    ('María', 'Gómez', 2, 'A1234567', '1988-09-20', 'Av. B, 456', '555-5678', 'maria@example.com', 2, 2),
    ('Carlos', 'López', 3, 'B9876543', '1995-02-10', 'Plaza C, 789', '555-9876', 'carlos@example.com', 3, 3);

-- Tabla de Profesores
CREATE TABLE Profesores (
    profesor_id SERIAL PRIMARY KEY,
    nombre_profesor VARCHAR(50) NOT NULL,
    apellido_profesor VARCHAR(50) NOT NULL,
    tipo_documento_id INT NOT NULL,
    numero_documento VARCHAR(20) NOT NULL UNIQUE,
    nacionalidad_id INT NOT NULL,
    curso_id INT NOT NULL, 
    correo_electronico_profesor VARCHAR(50) UNIQUE NOT NULL,
    FOREIGN KEY (tipo_documento_id) REFERENCES TiposDocumento(tipo_documento_id),
    FOREIGN KEY (nacionalidad_id) REFERENCES Nacionalidades(nacionalidad_id),
    FOREIGN KEY (curso_id) REFERENCES Cursos(curso_id)
);

INSERT INTO Profesores (nombre_profesor, apellido_profesor, tipo_documento_id, numero_documento, nacionalidad_id, curso_id, correo_electronico_profesor) VALUES
    ('Profesor', 'Uno', 1, 'P123456', 1, 1, 'profesor1@example.com'),
    ('Profesora', 'Dos', 2, 'D987654', 2, 2, 'profesora2@example.com'),
    ('Instructor', 'Tres', 3, 'I345678', 3, 3, 'instructor3@example.com');

-- Tabla intermedia Alumnos_Cursos para la relación N a N entre Alumnos y Cursos
CREATE TABLE Alumnos_Cursos (
    id_alumnos_cursos SERIAL PRIMARY KEY,
    alumno_id INT,
    curso_id INT,
    FOREIGN KEY (alumno_id) REFERENCES Alumnos(alumno_id),
    FOREIGN KEY (curso_id) REFERENCES Cursos(curso_id),
    UNIQUE (alumno_id, curso_id)
);

INSERT INTO Alumnos_Cursos (alumno_id, curso_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3);


-- Tabla intermedia Profesores_Cursos para la relación N a N entre Profesores y Cursos
CREATE TABLE Profesores_Cursos (
    id_profesores_cursos SERIAL PRIMARY KEY,
    profesor_id INT,
    curso_id INT,
    FOREIGN KEY (profesor_id) REFERENCES Profesores(profesor_id),
    FOREIGN KEY (curso_id) REFERENCES Cursos(curso_id),
    UNIQUE (profesor_id, curso_id)
);

-- Inserción de datos en Profesores_Cursos
INSERT INTO Profesores_Cursos (profesor_id, curso_id) VALUES
    (1, 1),
    (2, 2),
    (3, 3);