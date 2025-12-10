CREATE OR REPLACE VIEW public.vcantidades AS  SELECT ( SELECT DISTINCT count(*) AS cant_revistas
           FROM revistas) AS revistas,
    ( SELECT DISTINCT count(*) AS cant_area
           FROM ( SELECT DISTINCT revistas.area_conocimiento_id
                   FROM revistas) areas) AS cant_area,
    ( SELECT DISTINCT count(*) AS cant_indices
           FROM ( SELECT DISTINCT revistas.indice_id
                   FROM revistas) indices) AS cant_indices,
    ( SELECT DISTINCT count(*) AS cant_idiomas
           FROM ( SELECT DISTINCT revistas.idioma_id
                   FROM revistas) idiomas) AS cant_idiomas,
    ( SELECT DISTINCT count(*) AS cant_editoriales
           FROM ( SELECT DISTINCT revistas.editorial_id
                   FROM revistas) editoriales) AS cant_editoriales;;
CREATE OR REPLACE VIEW public.revistas_data AS  SELECT r.id,
    r.revista,
    ac.area_conocimiento,
    i.indice,
    id.idioma,
    e.editorial,
    p.periodicidad,
    f.formato,
    es.estado,
    r.nombres_editor,
    r.apellidos_editor,
    r.correo_editor,
    r.deposito_legal_impreso,
    r.deposito_legal_digital,
    r.issn_impreso,
    r.issn_digital,
    r.url,
    r.anio_inicial,
    r.direccion,
    r.telefono,
    r.resumen,
    r.portada
   FROM (((((((revistas r
     LEFT JOIN areas_conocimiento ac ON ((r.area_conocimiento_id = ac.id)))
     LEFT JOIN indices i ON ((r.indice_id = i.id)))
     LEFT JOIN idiomas id ON ((r.idioma_id = id.id)))
     LEFT JOIN editoriales e ON ((r.editorial_id = e.id)))
     LEFT JOIN periodicidad p ON ((r.periodicidad_id = p.id)))
     LEFT JOIN formatos f ON ((r.formato_id = f.id)))
     LEFT JOIN estados es ON ((r.estado_id = es.id)));;
CREATE OR REPLACE VIEW public.vdata_estados AS  SELECT b.estado,
    count(DISTINCT a.area_conocimiento_id) AS cantidad_area_conocimiento,
    count(DISTINCT a.indice_id) AS cantidad_indice,
    count(DISTINCT a.idioma_id) AS cantidad_idioma,
    count(DISTINCT a.revista) AS cantidad_revista,
    count(DISTINCT a.editorial_id) AS cantidad_editorial,
    count(DISTINCT a.periodicidad_id) AS cantidad_periodicidad,
    count(DISTINCT a.formato_id) AS cantidad_formato
   FROM (revistas a
     LEFT JOIN estados b ON ((b.id = a.estado_id)))
  GROUP BY b.estado;;
CREATE OR REPLACE VIEW public.vdata_nacional AS  SELECT 'TODOS'::text AS estado,
    count(DISTINCT area_conocimiento_id) AS cantidad_area_conocimiento,
    count(DISTINCT indice_id) AS cantidad_indice,
    count(DISTINCT idioma_id) AS cantidad_idioma,
    count(DISTINCT revista) AS cantidad_revista,
    count(DISTINCT editorial_id) AS cantidad_editorial,
    count(DISTINCT periodicidad_id) AS cantidad_periodicidad,
    count(DISTINCT formato_id) AS cantidad_formato
   FROM revistas a;;
CREATE OR REPLACE VIEW public.vestados AS  SELECT id,
    estado
   FROM estados
  ORDER BY
        CASE
            WHEN (id = 24) THEN 1
            WHEN (id = 14) THEN 2
            ELSE 3
        END, estado;;
CREATE OR REPLACE VIEW public.vroles_permissions AS  SELECT a.role_id,
    b.name AS rol,
    a.permission_id,
    c.name AS permission,
    c.description
   FROM ((role_permissions a
     LEFT JOIN roles b ON ((b.id = a.role_id)))
     LEFT JOIN permissions c ON ((c.id = a.permission_id)))
  ORDER BY b.name, c.name;;
