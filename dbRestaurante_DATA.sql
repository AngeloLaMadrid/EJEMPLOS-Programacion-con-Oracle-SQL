/*Eliminar tablas en orden:
DROP TABLE INSUMO;
DROP TABLE COMPRA_DETALLE;
DROP TABLE COMPRA;
DROP TABLE PROVEEDOR;
DROP TABLE PLATILLO;
DROP TABLE VENTA_DETALLE;
DROP TABLE VENTA;
DROP TABLE EMPLEADO;
DROP TABLE CLIENTE;
DROP TABLE UBIGEO;
*/
-- CREAR TABLAS
-- CREAR TABLA CLIENTE
CREATE TABLE CLIENTE (
    id_cliente int  NOT NULL,
    nombre Varchar2(25)  NOT NULL,
    apellido_paterno Varchar2(50)  NOT NULL,
    apellido_materno Varchar2(50)  NOT NULL,
    email Varchar2(50)  NOT NULL,
    dni char(8)  NOT NULL,
    celular Char(9)  NOT NULL,
    direccion Varchar2(50)  NOT NULL,
    estado Char(1)  DEFAULT 'A' NOT NULL,
    codigo_ubigeo char(6)  NOT NULL,
    CONSTRAINT CLIENTE_pk PRIMARY KEY (id_cliente)
) ;

-- -- CREAR TABLA  PLATILLO
CREATE TABLE PLATILLO (
    id_platillo Integer  NOT NULL,
    nombre Varchar2(20)  NOT NULL,
    precio decimal(10,2)  NOT NULL,
    descripcion Varchar2(500)  NOT NULL,
    categoria Char(1)  NOT NULL,
    stock int  NOT NULL,
    estado char(1)  DEFAULT 'A' NOT NULL,
    CONSTRAINT CODPLAT PRIMARY KEY (id_platillo)
) ;


-- -- CREAR TABLA  UBIGEO
CREATE TABLE UBIGEO (
    codigo_ubigeo char(6)  NOT NULL,
    departamento varchar2(50)  NOT NULL,
    provincia varchar2(50)  NOT NULL,
    distrito varchar2(50)  NOT NULL,
    CONSTRAINT UBIGEO_pk PRIMARY KEY (codigo_ubigeo)
) ;

-- -- CREAR TABLA  VENTA
CREATE TABLE VENTA (
    id_venta Integer  NOT NULL,
    fecha Date  NOT NULL,
    tipo_venta Char(1)  NOT NULL,
    estado Char(1)  DEFAULT 'A' NOT NULL,
    id_cliente Int  NOT NULL,
    id_empleado Int  NOT NULL,
    precio_total Decimal(8,2)  NOT NULL,
    CONSTRAINT VENTA_pk PRIMARY KEY (id_venta)
) ;

-- -- CREAR TABLA  VENTA_DETALLE
CREATE TABLE VENTA_DETALLE (
    id_ventaDetalle Integer  NOT NULL,
    cantidad_ventaDetalle Int  NOT NULL,
    id_venta Int  NOT NULL,
    id_platillo Int  NOT NULL,
    sub_total_ventaDetalle Decimal(8,2)  NOT NULL,
    estado Char(1)  DEFAULT 'A' NOT NULL,
    CONSTRAINT VENTA_DETALLE_pk PRIMARY KEY (id_ventaDetalle)
) ;



--------------------------TABLAS ANGELO-----------------------------------------

-- Tabla: Empleado
CREATE TABLE EMPLEADO (
    id_empleado integer  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre varchar2(50)  NOT NULL,
    apellidos varchar2(50)  NOT NULL,
    dni Char(8)  NOT NULL,
    email varchar2(50)  NOT NULL,
    celular char(9)  NOT NULL,
    tipo Char(1)  NOT NULL,
    estado Char(1)  DEFAULT 'A' NOT NULL
 
) ;

-- Tabla: INSUMO
CREATE TABLE INSUMO (
    id_insumo integer  GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre varchar2(50)  NOT NULL,
    stock number(8,2)  NOT NULL,
    unidad_medida varchar2(3)  NOT NULL,
    precio number(8,2)  NOT NULL,
    estado char(1) DEFAULT 'A'
) ;

-- Tabla: PROVEEDOR
CREATE TABLE PROVEEDOR (
    id_proveedor integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    razon_social varchar2(50)  NOT NULL,
    ruc char(11)  NOT NULL,
    estado char(1)  DEFAULT 'A'
) ;

--------------------------TRANSACCIONES ANGELO----------------------------------
-- Tabla: COMPRA
CREATE TABLE COMPRA (
    id_compra integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_empleado REFERENCES EMPLEADO(id_empleado),--RELACION
    id_proveedor REFERENCES PROVEEDOR(id_proveedor),--RELACION
    fecha timestamp  NOT NULL,
    estado char(1) DEFAULT 'A'
) ;

-- Tabla: COMPRA_DETALLE
CREATE TABLE COMPRA_DETALLE (
    id_compraDetalle integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_compra REFERENCES COMPRA(id_compra),--RELACION
    id_insumo REFERENCES INSUMO(id_insumo),--RELACION
    cantidad_compra_detalle integer  NOT NULL
) ;

-------------------------- FIN -------------------------------------------------

-- foreign keys
--  REFERENCIA CLIENTE_UBIGEO (table: CLIENTE)
ALTER TABLE CLIENTE ADD CONSTRAINT CLIENTE_UBIGEO
    FOREIGN KEY (codigo_ubigeo)
    REFERENCES UBIGEO (codigo_ubigeo);
    
-- REFERENCIA VENTA_CLIENTE (table: VENTA)
ALTER TABLE VENTA ADD CONSTRAINT VENTA_CLIENTE
    FOREIGN KEY (id_cliente)
    REFERENCES CLIENTE (id_cliente);

-- REFERENCIA VENTA_DETALLE_PLATILLO (table: VENTA_DETALLE)
ALTER TABLE VENTA_DETALLE ADD CONSTRAINT VENTA_DETALLE_PLATILLO
    FOREIGN KEY (id_platillo)
    REFERENCES PLATILLO (id_platillo);

-- REFERENCIA VENTA_DETALLE_VENTA (table: VENTA_DETALLE)
ALTER TABLE VENTA_DETALLE ADD CONSTRAINT VENTA_DETALLE_VENTA
    FOREIGN KEY (id_venta)
    REFERENCES VENTA (id_venta);

-- REFERENCIA VENTA_MESERO (table: VENTA)
ALTER TABLE VENTA ADD CONSTRAINT VENTA_MESERO
    FOREIGN KEY (id_empleado)
    REFERENCES EMPLEADO (id_empleado);
    

--------------------------------------------------- SECUENCIAS Y TRIGGERS -----------------------------------------------------
---SECUENCIAS
CREATE SEQUENCE INC_CLI
START WITH 1
INCREMENT BY 1;


---TRIGGERS
CREATE TRIGGER TRG_INC_CLI
  BEFORE INSERT ON CLIENTE
  FOR EACH ROW
  BEGIN
    SELECT INC_CLI.NEXTVAL INTO :NEW.id_cliente FROM DUAL;
  END;
  
-------------------------------------DATOS A LAS  TABLAS-------------------------------------------------------------------


---------------------------------------INSERTAR UBIEGEO------------------------------------------------------------
INSERT INTO UBIGEO
(CODIGO_UBIGEO,DEPARTAMENTO,PROVINCIA,DISTRITO)
   SELECT '140401', 'LIMA', 'CAÑETE', 'SAN VICENTE' FROM dual
UNION ALL

   SELECT '140402', 'LIMA', 'CAÑETE', 'CALANGO' FROM dual
UNION ALL

   SELECT '140403', 'LIMA', 'CAÑETE', 'CERRO AZUL' FROM dual
UNION ALL

   SELECT '140404', 'LIMA', 'CAÑETE', 'COAYLLO' FROM dual
UNION ALL

   SELECT '140405', 'LIMA', 'CAÑETE', 'CHILCA' FROM dual
UNION ALL

   SELECT '140406', 'LIMA', 'CAÑETE', 'IMPERIAL' FROM dual
UNION ALL

   SELECT '140407', 'LIMA', 'CAÑETE', 'LUNAHUANA' FROM dual
UNION ALL

   SELECT '140408', 'LIMA', 'CAÑETE', 'MALA' FROM dual
UNION ALL

   SELECT '140409', 'LIMA', 'CAÑETE', 'NUEVO IMPERIAL' FROM dual
UNION ALL

   SELECT '140410', 'LIMA', 'CAÑETE', 'PACARAN' FROM dual
UNION ALL

   SELECT '140411', 'LIMA', 'CAÑETE', 'QUILMANA' FROM dual
UNION ALL

   SELECT '140412', 'LIMA', 'CAÑETE', 'SAN ANTONIO' FROM dual
UNION ALL

   SELECT '140413', 'LIMA', 'CAÑETE', 'SANA LUIS' FROM dual
UNION ALL

   SELECT '140414', 'LIMA', 'CAÑETE', 'SANTA CRUZ DE FLORES' FROM dual
UNION ALL

   SELECT '140415', 'LIMA', 'CAÑETE', 'ZUÑIGA' FROM dual
UNION ALL

   SELECT '140416', 'LIMA', 'CAÑETE', 'ASIA' FROM dual
UNION ALL

   SELECT '140417', 'LIMA', 'CAÑETE', 'IMPERIAL' FROM dual
UNION ALL

   SELECT '140418', 'LIMA', 'CAÑETE', 'SAN VICENTE' FROM dual
UNION ALL

   SELECT '140419', 'LIMA', 'CAÑETE', 'SAN LUIS' FROM dual
UNION ALL

   SELECT '140420', 'LIMA', 'CAÑETE', 'CHILCA' FROM dual;
------------------------------------------------------------------------------------------------------------------------------


---------------------------------------Insertar datos en la tabla CLIENTE
INSERT INTO CLIENTE
(NOMBRE,APELLIDO_PATERNO,APELLIDO_MATERNO,EMAIL,DNI,CELULAR, DIRECCION,CODIGO_UBIGEO)
 SELECT 'JHON','MESTAS', 'ZAPATA','jhon@gmail.com','78032481','988745716','AV.SANTA ROSA','140401' FROM dual
UNION ALL

 SELECT 'JUAN','PEREZ','CHOQUE','juan@gmail.com','75032482','978748701','AV.SAN MIGUEL','140402' FROM dual
UNION ALL

 SELECT 'PABLO','RAMIREZ','APAZA','pablo@gmail.com','73042470','956745726','URB.SANTA ROSALIA','140403' FROM dual
UNION ALL

 SELECT 'RONALD','QUILLA',' MILA','ronald@gmail.com','78932410','967745756','URB.SANTA MARTA','140404' FROM dual
UNION ALL

 SELECT 'MIRIA','MESA',' MONTES','maria@gmail.com','74030480','988745706','AV.LUIS MIGUEL ','140405' FROM dual
UNION ALL

 SELECT 'MARTA','QUISPE',' MILLA','marta@gmail.com','74012480','988745705','URB.SAN FELIPE','140406' FROM dual
UNION ALL

 SELECT 'EDY','URTADO ','PADILLA','edy@gmail.com','74092482','958745709','URB.SAN CRISTOBAL','140407' FROM dual
UNION ALL

 SELECT 'PEDRO','LETI ','ZATA','pedro@gmail.com','74002480','988745704','AV.SAN ISIDRO','140408' FROM dual
UNION ALL

 SELECT 'JHON','ROJAS',' ZALA','jhon@gmail.com','74832486','988745702','AV.PANAMERICANA','140409' FROM dual
UNION ALL

 SELECT 'RAUL','CONDORI',' CHOQUE','raul@gmail.com','78012489','968745701','URB.SANTA CESILIA','140410' FROM dual
UNION ALL

 SELECT 'RICHART','MILAN',' CHOQUE','richart@gmail.com','75032482','978748701','AV.SAN MIGUEL','140411' FROM dual
UNION ALL

 SELECT 'JAIME','ZUBIETA',' APAZA','jaime@gmail.com','73042470','956745726','URB.SANTA ROSALIA','140412' FROM dual
UNION ALL

 SELECT 'BRANDON','LEON ','MILA','brandond@gmail.com','78932410','967745756','URB.SANTA MARTA','140413' FROM dual
UNION ALL

 SELECT 'ALICIA','MARTINEZ',' MONTES','ali@gmail.com','74032480','988745796','AV.LUIS MIGUEL','140414' FROM dual
UNION ALL

 SELECT 'IGNACIO','ARO',' MILLA','ignacio@gmail.com','74092680','988745705','URB.SAN FELIPE','140415' FROM dual
UNION ALL

 SELECT 'FREDDY','FLOREZ',' PADILLA','freddy@gmail.com','74032410','988745009','URB.SAN CRISTOBAL','140416' FROM dual
UNION ALL

 SELECT 'BORIS','MORALES',' ZATA','boris@gmail.com','74032497','988745704','AV.SAN ISIDRO','140417' FROM dual
UNION ALL

 SELECT 'GABRIEL','GARCIA',' ROJAS','gabo@gmail.com','79088489','988745702','AV.PANAMERICANA','140418' FROM dual
UNION ALL

 SELECT 'SAUL',' ALANDIA','MENDIETA','saul@gmail.com','78032481','968745701','AV.DEL VALLE','140419' FROM dual
UNION ALL

 SELECT 'ERICK','CANAVIRI ',' CRUZ','erick@gmail.com','78032486','967745741','URB.SANTA VENITA','140420' FROM dual;

---------------- -Insertar datos en la tabla EMPLEADO --------------------------
INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('JOSE','ORMEÑO GUITIERREZ','71032480','jose@gmail.com','988745706','A');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('JUAN','PEREZ CHOQUE','75032482','juan@gmail.com','978748701','M');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('PABLO','RAMIREZ APAZA','73042479','pablo@gmail.com','956745726','D');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('RONALD','QUILLA MILA','78932410','ronald@gmail.com','967745756','D');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('MIRIA','MESA MONTES','75092480','maria@gmail.com','988745766','M');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('MARTA','QUISPE MILLA','74032481','marta@gmail.com','988745705','M');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('EDY','URTADO PADILLA','14032480','edy@gmail.com','988745709','C');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('PEDRO','LETI ZATA','74032480','pedro@gmail.com','988745704','M');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('JHON','ROJAS ZALA','74932480','jhon@gmail.com','988745702','M');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('RAUL','CONDORI CHOQUE','7803O480','raul@gmail.com','968745701','C');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('RICHART','MILAN CHOQUE','75032482','richart@gmail.com','978748701','D');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('JAIME','ZUBI APAZA','18042470','jaime@gmail.com','956745726','C');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('BRANDON','LEON MILA','78932410','brandond@gmail.com','967745756','M');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('ALICIA','MARTINEZ MONTES','74032480','ali@gmail.com','988745706','C');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('IGNACIO','ARO MILLA','74032480','ignacio@gmail.com','988745705','A');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('FREDDY','FLOREZ PADILLA','74032410','freddy@gmail.com','988745709','D');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ( 'BORIS','MORALES ZATA','74032497','boris@gmail.com','988745704','A');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('GABRIEL','GARCIA ROJAS','79088489','gabo@gmail.com','988745702','C');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('SAUL',' ALANDIA MENDIETA','75032481','saul@gmail.com','968745701','C');

INSERT INTO EMPLEADO(nombre,apellidos,dni,email,celular,tipo)
VALUES ('ERICK','CANAVIRI CRUZ','78032486','erick@gmail.com','968745701','D');
------------------------------------------------------------------------------------------------
-- --------------------------------------------------inserta datos a PLATILLO----------------------------------------------------------------
INSERT INTO PLATILLO
(NOMBRE,PRECIO,DESCRIPCION,CATEGORIA,STOCK)
 SELECT 'LOMO SALTADO','15','Este Delicioso  Platillo Contiene Verduras, Carne de Res,Arroz y Papas fritas ','C','8' FROM dual
UNION ALL

 SELECT 'CHAUFA','12','Este Delicioso  Platillo  Contiene Mescla de Arroz frito, Verduras ,Tortilla de huevo y carne ','C','10' FROM dual
UNION ALL

 SELECT 'TALLARIN SALTADO','12','Este Delicioso  Platillo  Contiene Tallarin cocido,verduras y porciones de Carne ','C','8' FROM dual
UNION ALL

 SELECT 'CALDO DE GALLINA','15','Este Delicioso  Platillo Contiene Carne de Gallina,Tallarin huevo cocido ,cebolla','C','8' FROM dual
UNION ALL

 SELECT 'SOPA A LA MINUTA','12','Este Delicioso  Platillo Contiene Carne de Res o Pollo,tallarin y Verduras  ','C','10' FROM dual
UNION ALL

 SELECT 'AJI DE GALLINA','12','Este Delicioso  Platillo Contiene Carne de Gallina,Arroz y Papas fritas ','C','8' FROM dual
UNION ALL

 SELECT 'POLLO AL VINO','15','Este Delicioso  Platillo Contiene Carne de Pollo,Arroz y Papas fritas ','C','8' FROM dual
UNION ALL

 SELECT 'ARROZ CON POLLO','12','Este Delicioso  Platillo Contiene Carne de pollo Mescla de Arroz con Verduras ','C','6' FROM dual
UNION ALL

 SELECT 'CAU CAU','20','Este Delicioso  Platillo Contiene Arroz ,Modongo  con aji amarillo,Acompa?ado de un poco de carne y papa ','C','10' FROM dual
UNION ALL

 SELECT 'CEVICHE','12','Este Delicioso Platillo  contiene pescado, limones, cebollas, aj?es y culantro  ','C','10' FROM dual
UNION ALL

 SELECT 'CARAPULCRA ','12','Este Delicioso Platillo  contiene papa seca, carne de chancho ','C','8' FROM dual
UNION ALL

 SELECT 'CHANFAINITA','15','Este Delicioso  Platillo Contiene Carne de Rez,Mote, Papas picada y Aji Amarillo  ','C','6' FROM dual
UNION ALL

 SELECT 'SOPA CRIOLLA','12','Este Delicioso  Platillo contiene Tallarines ,Aji Amarillo ,Huevo frito ','C','10' FROM dual
UNION ALL

 SELECT 'SECO DE CARNE','12','Este Delicioso  Platillo  contiene Carne de Rez  , Arroz ,Frejoles, Verduras ','C','8' FROM dual
UNION ALL

 SELECT 'SOPA SECA','12','Este Delicioso  Platillo Contiene Tallarines ,Verduras ,Ajo,etc  ','C','10' FROM dual
UNION ALL

 SELECT 'TALLARIN CON POLLO','15','Este delicio Platillo  Contiene  Carne de pollo , Tallarines , Verduras  ','C','10' FROM dual
UNION ALL

 SELECT 'LOCRO DE ZAPALLO','12',' Este Delicioso  platillo Contiene Zapallo,queso,Papas ,etc','C','10' FROM dual
UNION ALL

 SELECT 'SECO DE PAVITA','20','Este Delicioso  Platillo Contiene Carne de rez ,Papa ,Arroz ,envuelto de Aji Picante ','C','10' FROM dual
UNION ALL

 SELECT 'TALLARINEZ VERDES','10','Este Delicioso  Platillo contiene Tallarines ,Cremas ','C','10' FROM dual
UNION ALL

 SELECT 'GUISO DE POLLO','12','Este Delicioso  Platillo Contiene Carne de Pollo,Arroz Aji Amarillo  ','C','8' FROM dual;
 
 -- VENTA
 select * from venta;
INSERT INTO VENTA
(FECHA,TIP0_VENTA,ID_CLIENTE,ID_EMPLEADO,PRECIO_TOTAL)
 SELECT '20/04/2023','P','1','1','39' FROM dual
UNION ALL

 SELECT '22/04/2023','D','2','2','39' FROM dual
UNION ALL

 SELECT '23/04/2023','P','3','3','47' FROM dual;
 
 --VENTA_DETALLE

INSERT INTO VENTA_DETALLE
(CANTiDAD_VENTADETALLE,ID_VENTA,ID_PLATILLO,SUB_TOTAL_VENTADETALLE)
 SELECT '1','1','1','15' FROM dual
UNION ALL

 SELECT '1','1','2','12' FROM dual
UNION ALL

 SELECT '1','1','3','12' FROM dual
UNION ALL


 SELECT '1','2','4','15' FROM dual
UNION ALL

 SELECT '1','2','5','12' FROM dual
UNION ALL

 SELECT '1','2','6','12' FROM dual
UNION ALL


 SELECT '1','3','7','15' FROM dual
UNION ALL

 SELECT '1','3','8','12' FROM dual
UNION ALL

 SELECT '1','3','9','20' FROM dual;
 SELECT * FROM VENTA WHERE IDVEN = '1';

SELECT * FROM VENTA_DETALLE WHERE IDVEN = '1';
 
--------------------------------------------------------------------------------------------- DATOS ANGELO -------------------------------------------------------------------
-- Insertar datos en la tabla PROVEEDOR
INSERT INTO PROVEEDOR (razon_social, ruc) VALUES ('Proveedor A', '12345678901');
INSERT INTO PROVEEDOR (razon_social, ruc) VALUES ('Proveedor B', '23456789012');
INSERT INTO PROVEEDOR (razon_social, ruc) VALUES ('Proveedor C', '34567890123');
INSERT INTO PROVEEDOR (razon_social, ruc) VALUES ('Proveedor D', '45678901234');
INSERT INTO PROVEEDOR (razon_social, ruc) VALUES ('Proveedor E', '56789012345');

-- Insertar datos en la tabla COMPRA

INSERT INTO COMPRA (id_empleado, id_proveedor, fecha) VALUES (1, 1, '04/09/2023');
INSERT INTO COMPRA (id_empleado, id_proveedor, fecha) VALUES (2, 2, '04/08/2023');
INSERT INTO COMPRA (id_empleado, id_proveedor, fecha) VALUES (3, 3, '04/07/2023');
INSERT INTO COMPRA (id_empleado, id_proveedor, fecha) VALUES (4, 4, '04/06/2023');
INSERT INTO COMPRA (id_empleado, id_proveedor, fecha) VALUES (5, 5, '04/05/2023');

-- Insertar datos en la tabla INSUMO
INSERT INTO INSUMO(nombre, stock, unidad_medida, precio) VALUES ('Arroz extra costeno', 5, 'kg',23.5);
INSERT INTO INSUMO(nombre, stock, unidad_medida, precio) VALUES ('Pasta trigo don vittorio', 950, 'g',6.30);
INSERT INTO INSUMO(nombre, stock, unidad_medida, precio) VALUES ('Aceite vegetal soya sao ', 900, 'mlt',9.40);
INSERT INTO INSUMO(nombre, stock, unidad_medida, precio) VALUES ('Sal', 1, 'kg',2.30);
INSERT INTO INSUMO(nombre, stock, unidad_medida, precio) VALUES ('Azucar rubia', 1, 'kg',4.60);
INSERT INTO INSUMO(nombre, stock, unidad_medida, precio) VALUES ('Harina preparada molitalia', 1, 'kg',6.90);
INSERT INTO INSUMO(nombre, stock, unidad_medida, precio) VALUES ('Leche gloria reconstituida', 400, 'g',4.00);
INSERT INTO INSUMO(nombre, stock, unidad_medida, precio) VALUES ('Queso mozarella bonle', 250, 'g',13.50);
INSERT INTO INSUMO(nombre, stock, unidad_medida, precio) VALUES ('Huevo pardos jumbo La Calera', 15, 'und',12.90);
INSERT INTO INSUMO(nombre, stock, unidad_medida, precio) VALUES ('Cebolla roja', 1, 'kg',2.69);
INSERT INTO INSUMO(nombre, stock, unidad_medida, precio) VALUES ('Ajo entero', 250, 'g',7.49);
INSERT INTO INSUMO(nombre, stock, unidad_medida, precio) VALUES ('Tomate italiano', 500, 'g',4.40);

-- Insertar datos en la tabla COMPRA_DETALLE
INSERT INTO COMPRA_DETALLE(id_compra, id_insumo, cantidad_compra_detalle)VALUES(1, 1, 10);
INSERT INTO COMPRA_DETALLE(id_compra, id_insumo, cantidad_compra_detalle)VALUES(1, 2, 5);
INSERT INTO COMPRA_DETALLE(id_compra, id_insumo, cantidad_compra_detalle)VALUES(2, 3, 20);
INSERT INTO COMPRA_DETALLE(id_compra, id_insumo, cantidad_compra_detalle)VALUES(3, 4, 8);
INSERT INTO COMPRA_DETALLE(id_compra, id_insumo, cantidad_compra_detalle)VALUES(4, 5, 15);


select * from insumo;
select * from compra;
select * from compra_detalle;