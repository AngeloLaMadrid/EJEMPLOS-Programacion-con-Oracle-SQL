
--Subqueries---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    --Single-row subquery---

    --Ejemplo 1: Obtener el nombre y apellidos de un EMPLEADO a partir de su ID de empleado en la tabla COMPRA. //TABLA PRINCIPAL=EMPLEADO, TABLA SECUNDARIA=COMPRA
    SELECT nombre, apellidos
    FROM EMPLEADO
    WHERE id_empleado = (SELECT id_empleado FROM COMPRA WHERE id_compra = 1);
    
    --Ejemplo 2: Obtener el nombre del EMPLEADO que realizó una COMPRA y su estado sea 'A' (activo) en la tabla EMPLEADO.  //TABLA PRINCIPAL=EMPLEADO, TABLA SECUNDARIA=COMPRA
    SELECT nombre, estado
    FROM EMPLEADO
    WHERE id_empleado = (SELECT id_empleado FROM COMPRA WHERE id_compra = 3
    AND estado = 'A');
    
    --Ejemplo 3: Obtener el nombre y precio de un INSUMO menor a 5 que se realizo en el COMPRA_DETALLE //TABLA PRINCIPAL=INSUMO, TABLA SECUNDARIA=COMPRA_DETALLE
    select nombre, precio
    FROM INSUMO 
    WHERE id_insumo = (SELECT id_insumo FROM COMPRA_DETALLE WHERE id_compradetalle= 5
    AND precio < 5.0);
    
    
    --Multiple-row subquery--
    
    --Ejemplo 1: Obtener los nombres de los empleados que han realizado compras. //JOSE, JUAN, PABLO, RONALD y MIRIA
    SELECT nombre, apellidos
    FROM EMPLEADO
    WHERE id_empleado IN (SELECT id_empleado FROM COMPRA);
    
    --Ejemplo 2: Obtener los empleados que no han realizado ninguna compra
    SELECT nombre, apellidos
    FROM empleado
    WHERE id_empleado NOT IN (SELECT id_empleado FROM compra);
    
    
    --Ejemplo 3: Obtener nombre y apellidos de los empleados cuyo ID coincide con algunos proveedores en la tabla COMPRA.
    SELECT nombre, apellidos
    FROM EMPLEADO
    WHERE id_empleado = ANY (SELECT id_proveedor FROM PROVEEDOR);





--Ensuring Quality Queries Ejemplos-----------------------------------------------------------------------------------------------------------------------------------

    /*Problema 1: Consultar el nombre y apellidos de los empleados y la fecha de compra de todas las compras realizadas. //JOSE, JUAN, PABLO, RONALD y MIRIA
    DIFERENCIA1: La primera consulta realiza un duplicado de datos
    DIFERENCIA2: Ademas de que no tiene la buena practica de especificar donde van las tablas 
    DIFERENCIA3: Mala practica de llamar las tablas directamente, por ello se usa el INNER JOIN, gracias a este no se repiten los datos*/
    
    --Consulta INCORRECTA:
    SELECT nombre, apellidos, TO_CHAR(fecha, 'DD/MM/YY HH:MI') AS fecha_hora
    FROM EMPLEADO, COMPRA;
    
    
    --Consulta  CORRECTA:
    SELECT E.nombre, E.apellidos, TO_CHAR(C.fecha, 'DD/MM/YY HH:MI') AS fecha_hora
    FROM EMPLEADO E 
    INNER JOIN COMPRA C ON E.id_empleado = C.id_empleado;
    
    
    /*Problema 2: Obtener el nombre y apellidos de los empleados que tienen compras registradas y su estado es 'A'.
    DIFERENCIA: La primera consulta realiza un duplicado de datos  
    DIFERENCIA2: Mala practica de llamar las tablas directamente, por ello se usa el INNER JOIN, gracias a este no se repiten los datos
    OPTIMIZACION: EMPLEADO.nombre ---> E.nombre */
    
    --Consulta INCORRECTA:
    SELECT EMPLEADO.nombre, EMPLEADO.apellidos, empleado.estado
    FROM EMPLEADO
    WHERE estado = 'A';
    
    --Consulta  CORRECTA:
    SELECT E.nombre, E.apellidos, E.estado
    FROM EMPLEADO E
    INNER JOIN COMPRA C ON E.id_empleado = C.id_empleado
    WHERE E.estado = 'A';
    
    
    /*Problema 3: Mostrar todos los empleados junto con sus respectivas compras
    (incluso si no tienen ninguna compra registrada).
    DIFERENCIA OPTIMIZACION: EMPLEADO.nombre ---> E.nombre */
    
    --Consulta INCORRECTA:
    SELECT EMPLEADO.nombre, EMPLEADO.apellidos, COMPRA.fecha
    FROM EMPLEADO
    LEFT JOIN COMPRA ON EMPLEADO.id_empleado = COMPRA.id_empleado;
    
    --Consulta  CORRECTA:
    SELECT E.nombre, E.apellidos, C.fecha
    FROM EMPLEADO E
    LEFT JOIN COMPRA C ON E.id_empleado = C.id_empleado;
    
    
    /*Problema 4: Obtener el número total de compras realizadas por cada empleado.
    DIFERENCIA 1: La primera consulta trae todas las compras realizadas por empleado, incluso si los empleados no hicieron compras y eso esta mal
    DIFERENCIA OPTIMIZACION: EMPLEADO.nombre ---> E.nombre */
    
    --Consulta INCORRECTA:
    SELECT EMPLEADO.nombre, EMPLEADO.apellidos, COUNT(COMPRA.id_compra) AS total_compras
    FROM EMPLEADO
    LEFT JOIN COMPRA ON EMPLEADO.id_empleado = COMPRA.id_empleado
    GROUP BY EMPLEADO.nombre, EMPLEADO.apellidos, EMPLEADO.id_empleado;
    
    
    --Consulta  CORRECTA:
    SELECT E.nombre, E.apellidos, COUNT(C.id_compra) AS total_compras
    FROM EMPLEADO E
    INNER JOIN COMPRA C ON E.id_empleado = C.id_empleado
    GROUP BY E.nombre, E.apellidos;

--Data Manipulation Language---------------------------------------------------------------------------------------------------------------------------------------------

    --Agregar un nuevo registro  a la tabla EMPLEADO: JUAN PEREZ QUISPE
    INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
    VALUES ('JUAN','PEREZ QUISPE','58148525','jose@gmail.com','987654320','C');
    
    SELECT * FROM EMPLEADO 
    WHERE dni = '58148525';
    
    --Editar el celular del EMPLEADO: JUAN PEREZ QUISPE
    UPDATE EMPLEADO SET celular= '999999909' 
    WHERE dni = '58148525';
    SELECT * FROM EMPLEADO 
    WHERE dni = '58148525';
    
    --Eliminar definitivamente al EMPLEADO: JUAN PEREZ QUISPE
    DELETE FROM EMPLEADO
    WHERE dni = '58148525';
    SELECT * FROM EMPLEADO 
    WHERE dni = '58148525';
    
    --Valores default
    
    --Para este ejemplo ya existe un valor por defecto es estado el cual es "A": tipo CHAR(1) DEFAULT 'A'
    
    -- Crear tabla origen: tablaTemporal_1
    CREATE TABLE tablaTemporal_1 (
        id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        nombre VARCHAR2(50),
        dni CHAR(8),
        tipo CHAR(1) DEFAULT 'A'
    );
    
    -- Crear tabla destino: tablaTemporal_2
    CREATE TABLE tablaTemporal_2 (
        id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        nombre VARCHAR2(50),
        dni CHAR(8),
        tipo CHAR(1) DEFAULT 'B'
    );

    
    -- Insertar datos en tablaTemporal_1------------------------
    INSERT INTO tablaTemporal_1 ( nombre, dni)VALUES ( 'Juan', '12345678');
    INSERT INTO tablaTemporal_1 ( nombre, dni)VALUES ( 'María', '87654321');
    INSERT INTO tablaTemporal_1 ( nombre, dni)VALUES ( 'Pedro', '98765432');
    INSERT INTO tablaTemporal_1 ( nombre, dni)VALUES ( 'Rosa', '44441111');
    INSERT INTO tablaTemporal_1 ( nombre, dni)VALUES ( 'Mario', '44442222');
    
    -- Insertar datos en tablaTemporal_2------------------------
    INSERT INTO tablaTemporal_2 ( nombre, dni)VALUES ( 'Ana', '11111111');
    INSERT INTO tablaTemporal_2 ( nombre, dni)VALUES ( 'Luis', '22222222');
    INSERT INTO tablaTemporal_2 ( nombre, dni)VALUES ( 'Laura', '33333333');
    
    --Listar tablas
    select * from tablaTemporal_1;--tabla ORIGEN
    select * from tablaTemporal_2 ;--tabla DESTINO

--MERGE ---------------------------------------------------------------------------------------------------------------------------------------------

    --Tabla que va a cambiar
    select * from tablaTemporal_2 ;--tabla DESTINO
    
    -- Realizar el MERGE, sabiendo que tabla ORIGEN: tablaTemporal_1 Y tabla DESTINO: tablaTemporal_2
    MERGE INTO tablaTemporal_2 t2 --Destino
    USING tablaTemporal_1 t1    --Origen
    ON (t2.id = t1.id)  --Busca coincidencia
    WHEN MATCHED THEN
        UPDATE SET 
         t2.dni = t1.dni,
         t2.tipo = t1.tipo
    WHEN NOT MATCHED THEN
        INSERT ( nombre, dni, tipo)
        VALUES ( 'Otros', '00000000','C');
    
    --Listar tablas
    select * from tablaTemporal_1;--tabla ORIGEN
    select * from tablaTemporal_2 ;--tabla DESTINO
    
    --Eliminar tablas
    drop table tablaTemporal_1 ;
    drop table tablaTemporal_2;




--Multi-Table Inserts--

--Agregar 3 datos a clientes
INSERT ALL
    INTO CLIENTE (NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, EMAIL, DNI, CELULAR, DIRECCION, CODIGO_UBIGEO) VALUES ('Sam', 'Bustos', 'Galvez', 'sambus@gmail.com', '00000003', '988745716', 'AV.SANTA ROSA', '140401')
    INTO CLIENTE (NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, EMAIL, DNI, CELULAR, DIRECCION, CODIGO_UBIGEO) VALUES ('Juan', 'Ramirez', 'Choque', 'juanram@gmail.com', '00000002', '978748701', 'AV.SAN MIGUEL', '140402')
    INTO CLIENTE (NOMBRE, APELLIDO_PATERNO, APELLIDO_MATERNO, EMAIL, DNI, CELULAR, DIRECCION, CODIGO_UBIGEO) VALUES ('Isaac', 'Quispe', 'Perez', 'isaaquis@gmail.com', '00000001', '956745726', 'URB.SANTA ROSALIA', '140403')
SELECT * FROM dual;

--Listar los nuevos datos
SELECT * FROM CLIENTE WHERE DNI IN ('00000003', '00000002', '00000001');

--Eliminar los nuevos datos
DELETE FROM CLIENTE WHERE DNI IN ('00000003', '00000002', '00000001');

