DROP TABLE IF EXISTS instance_relationships_ext;

-- Create a local table that includes the name and id for the relationship type
CREATE TABLE instance_relationships_ext AS
SELECT
    relationships.id AS relationship_id,
    json_extract_path_text(relationships.data, 'instanceRelationshipTypeId') AS relationship_type_id,
    json_extract_path_text(types.data, 'name') AS relationship_type_name,
    json_extract_path_text(relationships.data, 'subInstanceId') AS relationship_sub_instance_id,
    json_extract_path_text(relationships.data, 'superInstanceId') AS relationship_super_instance_id
FROM
    inventory_instance_relationships AS relationships
    LEFT JOIN inventory_instance_relationship_types AS types
        ON types.id = json_extract_path_text(relationships.data, 'instanceRelationshipTypeId');

