-- Access control
CREATE ROLE test_role ON CLUSTER 'shardedreplicated'

GRANT SELECT ON numbers TO test_role ON CLUSTER 'shardedreplicated'
GRANT SELECT ON numbers_dist TO test_role ON CLUSTER 'shardedreplicated'

CREATE user test_user ON CLUSTER 'shardedreplicated'
GRANT test_role TO test_user ON CLUSTER 'shardedreplicated'
CREATE ROW POLICY numbers_test_user ON numbers_dist USING numberID=10 TO test_user ON CLUSTER 'shardedreplicated'
CREATE ROW POLICY numbers_test_user ON numbers USING numberID=10 TO test_user ON CLUSTER 'shardedreplicated'

CREATE user test_user_admin ON CLUSTER 'shardedreplicated'
GRANT test_role TO test_user_admin ON CLUSTER 'shardedreplicated'