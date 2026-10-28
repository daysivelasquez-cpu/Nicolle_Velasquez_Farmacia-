# Farmacia - Inventario por lotes y vencimientos 
Estudiante: Daysi Nicolle Velasquez Chaver 

Sistema para control de inventario por lotes con fechas y vencimientos

# Tablas 
- categorias , productos (nombre, categoria_id, precio, requiere_receta)
- proveedores , lotes (producto_id, proveedor_id, numero_lote, fecha_vencimiento, cantidad)
- Ventas (fecha, total, usuario_id) 
- detalle_venta (venta_id, lote_id, cantidad, precio).

# Reglas de negocio 
1. No vender lotes vencidos
2. Descontar del lote que vence antes
3. Stock nunca negativo

#  Vistas del sistema (El sistema contemplados vistas): 
- Empleado(usuario con rol vendedor/Admin) y Cliente(cliente registrado en la tabla vinculado las ventas)

#  Flujo del sistema
1. El cliente o empleado busca un producto.
2. El sistema verifica el stock y la fecha de vencimiento en la tabla lotes.
3. La empresa registra la venta en la tabla ventas, ligada a un usuario y a un cliente.
4. El sistema descuenta automáticamente del inventario (lotes y productos) y guarda el detalle en detalle_venta.

# Reto propio 
- GET /lotes/por-vencer?dias=30
- Reporte valor inventario por categoría

# Diagramas 
- diagrama_ER.png
- diagrama_UML.png 
