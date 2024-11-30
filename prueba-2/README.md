# Prueba 2

## Alumno
- Nombre: Gustavo Ferreira de Oliveira
RUT: 400162816

## Enunciado

Una tienda de ventas de productos desea mejorar su sistema de gestión y control, actualmente realizado de forma manual, hacia un sistema electrónico que permita una mayor eficiencia en la administración de clientes, productos y ventas. La tienda trabaja con una amplia variedad de productos, organizados por categorías, cada una representando un grupo de artículos similares, como electrónicos, ropa o alimentos. Cada producto tiene un precio, una cantidad en inventario y está asociado a una categoría específica, lo que facilita una mejor organización del stock.

Los productos de la tienda son suministrados por diferentes proveedores. Cada proveedor cuenta con un nombre, información de contacto y es responsable del abastecimiento de ciertos productos, lo que facilita la reposición del inventario y la negociación de nuevos contratos. Para atender mejor a sus clientes, la tienda también desea gestionar información detallada sobre ellos, incluyendo nombre, correo electrónico y teléfono, permitiendo una relación más cercana y la oferta de promociones personalizadas.

Las ventas realizadas por la tienda se registran en el sistema, asociando cada venta a un cliente y a un empleado que realizó la transacción. Cada venta incluye información como la fecha, el valor total y el método de pago, lo que posibilita análisis detallados sobre el rendimiento y las preferencias de los clientes. Además, como las ventas pueden involucrar varios productos, es necesario registrar la cantidad de cada artículo vendido, asegurando un control preciso del inventario.

La tienda también cuenta con gerentes responsables de supervisar las operaciones y el desempeño de los empleados. Cada gerente tiene un nombre, un correo electrónico, un teléfono y está asociado a un conjunto de empleados, permitiendo una gestión más efectiva del personal y una clara jerarquía administrativa. Además, los gerentes participan en la toma de decisiones estratégicas, como la implementación de promociones o ajustes en el inventario.

Para gestionar situaciones como devoluciones, el sistema permitirá registrar cuando un cliente devuelve un producto, incluyendo la fecha de la devolución y el motivo, ayudando a la tienda a monitorear la calidad de los productos y la satisfacción de los clientes. Además, la tienda frecuentemente realiza promociones y ofertas, aplicando descuentos en productos específicos durante períodos determinados. Estas promociones se registran con detalles como el porcentaje de descuento y las fechas de inicio y término, para garantizar que los precios se apliquen correctamente.

El control del inventario es una prioridad para la tienda, siendo necesario registrar ajustes manuales realizados en el stock, ya sea para corregir errores, contabilizar pérdidas o actualizar cantidades. Cada ajuste debe incluir información como el producto afectado, la cantidad ajustada, el motivo y la fecha del ajuste. Con este sistema, la tienda podrá mantener un control más eficiente de sus operaciones, mejorar la atención al cliente y tomar decisiones basadas en datos confiables.


### Requisitos  

1. **Cliente**  
   - Atributos: `ID`, `Nombre`, `Correo`, `Teléfono`.  
   - Descripción: Representa los clientes que realizan compras en la tienda.  

2. **Producto**  
   - Atributos: `ID`, `Nombre`, `Precio`, `Cantidad en Inventario`, `CategoríaID`.  
   - Descripción: Almacena los productos disponibles para la venta.  

3. **Categoría**  
   - Atributos: `ID`, `Nombre`, `Descripción`.  
   - Descripción: Agrupa productos similares para facilitar su gestión.  

4. **Proveedor**  
   - Atributos: `ID`, `Nombre`, `Teléfono`, `Correo`.  
   - Descripción: Representa las empresas que suministran los productos.  

5. **Empleado**  
   - Atributos: `ID`, `Nombre`, `Correo`, `Teléfono`.  
   - Descripción: Almacena información de los empleados responsables de las ventas.  

6. **Gerente**  
   - Atributos: `ID`, `Nombre`, `Correo`, `Teléfono`.  
   - Descripción: Supervisores responsables de las operaciones y del desempeño de los empleados.  

7. **Venta**  
   - Atributos: `ID`, `Fecha`, `Valor Total`, `Método de Pago`, `ClienteID`, `EmpleadoID`.  
   - Descripción: Representa las ventas realizadas en la tienda.  

8. **Detalle de Venta**  
   - Atributos: `ID`, `VentaID`, `ProductoID`, `Cantidad`, `Precio Unitario`.  
   - Descripción: Especifica los productos vendidos en cada transacción.  

9. **Devolución**  
   - Atributos: `ID`, `Fecha`, `Motivo`, `ProductoID`, `ClienteID`.  
   - Descripción: Almacena devoluciones realizadas por los clientes.  

10. **Promoción**  
    - Atributos: `ID`, `ProductoID`, `Porcentaje de Descuento`, `Fecha Inicio`, `Fecha Fin`.  
    - Descripción: Registra descuentos aplicados a productos durante un período determinado.  


---

### **Trabajo a realizar**

1. **Modelado conceptual (DER):** Diseñe el Diagrama Entidad-Relación que represente la problemática descrita, incluyendo todas las entidades mencionadas en los requisitos. [10%]  
   
2. **Modelo relacional:** Transforme el DER en un Modelo Relacional, asegurándose de que las tablas estén normalizadas a BCNF, y considere las relaciones entre gerentes, empleados y demás entidades. [6%]  

3. **Creación de tablas:** Genere el SQL para crear las tablas correspondientes al Modelo Relacional, incluyendo restricciones de integridad como claves primarias, claves foráneas y atributos únicos. [6%]  

4. **Inserción de datos:** Escriba los SQL para realizar las siguientes inserciones: [39%]  
   - Ingrese 3 clientes.  
   - Ingrese 5 productos distribuidos en al menos 2 categorías.  
   - Ingrese 3 proveedores y asocie cada uno con al menos un producto.  
   - Ingrese 3 empleados.  
   - Ingrese 1 gerente y asocie al menos 2 empleados a su supervisión.  
   - Registre 2 ventas con los siguientes detalles:  
     - Venta 1: Cliente A compra 2 productos el 2024-03-01 por $100.000, gestionada por el Empleado 1.  
     - Venta 2: Cliente B compra 1 producto el 2024-03-15 por $50.000, gestionada por el Empleado 2.  
   - Registre 1 devolución: Cliente A devuelve un producto de la Venta 1 el 2024-03-20.  
   - Ingrese 2 ofertas activas para algunos productos.  
   - Realice un ajuste de inventario para 2 productos el 2024-04-01.  

5. **Consultas:** Escriba las consultas SQL para responder lo siguiente: [39%]  
   a. Liste todos los clientes y sus compras, incluyendo a aquellos sin compras.  
   b. Liste los productos, indicando su stock actual, y si están en oferta, muestre el precio con descuento.  
   c. Identifique a los empleados que no han gestionado ninguna venta.  
   d. Liste los productos devueltos, indicando la razón de la devolución.  
   e. Indique el producto más vendido y el menos vendido.  
   f. Calcule el ingreso total generado por categoría de producto.  
   g. Identifique a los proveedores que más productos han suministrado.  
   h. Liste los gerentes y los empleados bajo su supervisión, incluyendo gerentes sin empleados asignados.  

6. **Triggers y funciones:**  
   a. Cree 2 triggers:  
      - Uno que actualice automáticamente el stock de un producto al registrarse una venta o devolución.  
      - Otro que registre el histórico de ajustes de inventario.  
   b. Cree 3 funciones:  
      - Una que retorne los productos más vendidos en un rango de fechas.  
      - Otra que retorne los ingresos generados por un cliente específico.  
      - Otra que registre automáticamente una venta a partir de un cliente, empleado y productos seleccionados, actualizando el stock de forma dinámica.  

