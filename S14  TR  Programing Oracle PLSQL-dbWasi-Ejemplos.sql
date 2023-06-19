--Activar para ver los mensajes en la consola.
SET SERVEROUTPUT ON;


--------------------------------------------------------------------------------
------------------Uso de atributos de cursor explícitos-------------------------
--------------------------------------------------------------------------------

-- Ejemplo 1: Verificar si existen insumos disponibles
DECLARE
  CURSOR c_insumos IS
    SELECT * FROM insumo WHERE stock > 0; -- Cursor que selecciona los insumos con stock mayor a 0
    v_insumo insumo%ROWTYPE; -- Declarar una variable de tipo insumo para almacenar el resultado
BEGIN
  OPEN c_insumos; -- Abrir el cursor
      FETCH c_insumos INTO v_insumo; -- Leer el primer registro del cursor y almacenarlo en la variable v_insumo
    
      IF c_insumos%FOUND THEN -- Verificar si el cursor tiene filas**
        DBMS_OUTPUT.PUT_LINE('Existen insumos disponibles.'); -- Mostrar mensaje indicando que existen insumos disponibles
      ELSE
        DBMS_OUTPUT.PUT_LINE('No hay insumos disponibles.'); -- Mostrar mensaje indicando que no hay insumos disponibles
      END IF;
  CLOSE c_insumos; -- Cerrar el cursor
END;



-- Ejemplo 2: Obtener el estado de un insumo específico utilizando el atributo %FOUND del cursor
DECLARE
  CURSOR c_insumo IS
    SELECT estado FROM insumo WHERE id_insumo = 6; -- Cambiar el id según el insumo deseado
  v_estado insumo.estado%TYPE; -- Declarar una variable para almacenar el estado del insumo
BEGIN
  OPEN c_insumo; -- Abrir el cursor
      FETCH c_insumo INTO v_estado; -- Leer el estado del insumo y almacenarlo en la variable v_estado
    
      IF c_insumo%FOUND THEN -- Verificar si el cursor tiene filas**
        DBMS_OUTPUT.PUT_LINE('El estado del insumo es: ' || v_estado); -- Mostrar el estado del insumo
      ELSE
        DBMS_OUTPUT.PUT_LINE('No se encontró el insumo'); -- Mostrar mensaje indicando que el insumo no fue encontrado
      END IF;
  CLOSE c_insumo; -- Cerrar el cursor
END;



-- Ejemplo 3: Verificar si el cursor está abierto y contiene filas
DECLARE
  CURSOR c_empleados IS SELECT * FROM empleado; -- Declarar el cursor para seleccionar todos los empleados
BEGIN
  OPEN c_empleados; -- Abrir el cursor
      IF c_empleados%ISOPEN THEN -- Verificar si el cursor está abierto**
        DBMS_OUTPUT.PUT_LINE('El cursor está abierto'); -- Mostrar mensaje indicando que el cursor está abierto
      ELSE
        DBMS_OUTPUT.PUT_LINE('El cursor está cerrado'); -- Mostrar mensaje indicando que el cursor está cerrado
      END IF;
  CLOSE c_empleados; -- Cerrar el cursor
END;


-- Ejemplo 4: Actualizar el estado de los insumos con precios mayores a 40.00 y mostrar el número de registros actualizados:

--Para empezar, se agregan 5 nuevos datos a la tabla Insumo con precios mayores a 40.00
INSERT INTO insumo (nombre, stock, unidad_medida, precio)
SELECT 'Insumo 1', 10, 'kg', 50.00 FROM DUAL UNION ALL
SELECT 'Insumo 2', 5, 'lts', 55.00 FROM DUAL UNION ALL
SELECT 'Insumo 3', 8, 'und', 60.00 FROM DUAL UNION ALL 
SELECT 'Insumo 4', 12, 'kg', 45.00 FROM DUAL UNION ALL
SELECT 'Insumo 5', 3, 'lts', 70.00 FROM DUAL;

--Ejecutar el ejemplo--------------
SELECT constraint_name, column_name
FROM all_constraints
WHERE table_name = 'INSUMO' AND constraint_type = 'U';
DECLARE
  v_num_actualizados INTEGER; -- Variable para almacenar el número de registros actualizados
BEGIN
  UPDATE insumo SET estado = 'I' WHERE precio > 40.00; -- 1er ejemplo: cambiar el estado a 'I'
  --DELETE insumo WHERE precio > 40.00; -- 2do ejemplo: eliminar los insumos
  
  v_num_actualizados := SQL%ROWCOUNT; -- Obtener el número de registros actualizados utilizando el atributo %ROWCOUNT **
  IF v_num_actualizados > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Número de insumos actualizados: ' || v_num_actualizados);
  ELSE
    DBMS_OUTPUT.PUT_LINE('No se encontraron insumos para actualizar');
  END IF;
END;

select * from insumo where id_insumo >14;
delete  from insumo where id_insumo >14;

--------------------------------------------------------------------------------
------------------Bucles FOR del cursor-----------------------------------------
--------------------------------------------------------------------------------

--Ejemplo 1: Verificar si existen insumos disponibles
DECLARE
  v_num_insumos INTEGER := 0;--se inicializa con el valor 0, de lo contrario 
BEGIN
  FOR rec_insumo IN (SELECT * FROM insumo WHERE stock > 0) LOOP
    v_num_insumos := v_num_insumos + 1;
  END LOOP;
  IF v_num_insumos > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Existen insumos disponibles.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No hay insumos disponibles.');
  END IF;
END;



--Ejemplo 2: Recorrer y mostrar los nombres de todos los empleados
DECLARE
  v_nombre_empleado VARCHAR2(50); -- Variable para almacenar el nombre de cada empleado
BEGIN
  FOR rec_empleado IN (SELECT nombre FROM empleado) LOOP -- Bucle FOR que recorre el cursor de empleados
    v_nombre_empleado := rec_empleado.nombre; -- Asignar el nombre del empleado actual a la variable
    DBMS_OUTPUT.PUT_LINE('Nombre de empleado: ' || v_nombre_empleado); -- Mostrar el nombre del empleado
  END LOOP;
END;



--Ejemplo 3: Calcular el total de stock de todos los insumos
DECLARE
  v_total_stock NUMBER := 0; -- Variable para almacenar el total de stock de los insumos
BEGIN
  FOR rec_insumo IN (SELECT stock FROM insumo) LOOP
    v_total_stock := v_total_stock + rec_insumo.stock; -- Sumar el stock del insumo actual al total
    -- Puedes realizar otras operaciones con el stock del insumo si es necesario
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Total de stock de insumos: ' || v_total_stock);  -- Muestra el total de stock de los insumos
END;



--------------------------------------------------------------------------------
------------------Cursors with Parameters---------------------------------------
--------------------------------------------------------------------------------

DECLARE
  CURSOR c_ventas_cliente (p_id_cliente NUMBER) IS
    SELECT * FROM venta WHERE id_cliente = p_id_cliente;
  v_venta venta%ROWTYPE;
BEGIN
  OPEN c_ventas_cliente(1);
  LOOP
    FETCH c_ventas_cliente INTO v_venta;
    EXIT WHEN c_ventas_cliente%NOTFOUND;
    -- Realizar operaciones con los datos de la venta
    -- ...
  END LOOP;
  CLOSE c_ventas_cliente;
END;


DECLARE
  CURSOR c_empleados(p_tipo IN VARCHAR2) IS -- Cursor con parámetro p_tipo
    SELECT * FROM empleado WHERE tipo = p_tipo;
  v_empleado empleado%ROWTYPE;
BEGIN
  OPEN c_empleados('A'); -- Uso del cursor con parámetro
  LOOP
    FETCH c_empleados INTO v_empleado;
    EXIT WHEN c_empleados%NOTFOUND;
    -- Realizar operaciones con el empleado
  END LOOP;
  CLOSE c_empleados;
END;



--------------------------------------------------------------------------------
------------------Cursors For Update-------------------------------------------
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
------------------Multiple Cursors----------------------------------------------
--------------------------------------------------------------------------------
DECLARE
  -- Cursores
  CURSOR cur_empleados IS
    SELECT id_empleado, nombre, apellidos, dni
    FROM EMPLEADO
    WHERE estado = 'A'; -- Empleados activos

  CURSOR cur_insumos IS
    SELECT id_insumo, nombre, stock, unidad_medida
    FROM INSUMO
    WHERE estado = 'A'; -- Insumos activos

  -- Variables para empleados
  v_id_empleado EMPLEADO.id_empleado%TYPE;
  v_nombre EMPLEADO.nombre%TYPE;
  v_apellidos EMPLEADO.apellidos%TYPE;
  v_dni EMPLEADO.dni%TYPE;

  -- Variables para insumos
  v_id_insumo INSUMO.id_insumo%TYPE;
  v_nombre_insumo INSUMO.nombre%TYPE;
  v_stock INSUMO.stock%TYPE;
  v_unidad_medida INSUMO.unidad_medida%TYPE;
BEGIN
  -- Abrir los cursores
  OPEN cur_empleados;
  OPEN cur_insumos;

  -- Recorrer y mostrar empleados
  DBMS_OUTPUT.PUT_LINE('Empleados:');
  LOOP
    FETCH cur_empleados INTO v_id_empleado, v_nombre, v_apellidos, v_dni;
    EXIT WHEN cur_empleados%NOTFOUND;

    -- Mostrar los datos del empleado
    DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_empleado);
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre);
    DBMS_OUTPUT.PUT_LINE('Apellidos: ' || v_apellidos);
    DBMS_OUTPUT.PUT_LINE('DNI: ' || v_dni);
    DBMS_OUTPUT.PUT_LINE('');
  END LOOP;

  -- Recorrer y mostrar insumos
  DBMS_OUTPUT.PUT_LINE('Insumos:');
  LOOP
    FETCH cur_insumos INTO v_id_insumo, v_nombre_insumo, v_stock, v_unidad_medida;
    EXIT WHEN cur_insumos%NOTFOUND;

    -- Mostrar los datos del insumo
    DBMS_OUTPUT.PUT_LINE('ID: ' || v_id_insumo);
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre_insumo);
    DBMS_OUTPUT.PUT_LINE('Stock: ' || v_stock);
    DBMS_OUTPUT.PUT_LINE('Unidad de Medida: ' || v_unidad_medida);
    DBMS_OUTPUT.PUT_LINE('');
  END LOOP;

  -- Cerrar los cursores
  CLOSE cur_empleados;
  CLOSE cur_insumos;
END;
/
