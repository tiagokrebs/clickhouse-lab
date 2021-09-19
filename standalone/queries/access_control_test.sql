-- Access control
CREATE ROLE test_role;

GRANT SELECT ON numbers TO test_role;
GRANT SELECT ON numbers_dist TO test_role;

CREATE user test_user;
GRANT test_role TO test_user;
CREATE ROW POLICY numbers_test_user ON numbers_dist USING numberID=10 TO test_user;
CREATE ROW POLICY numbers_test_user ON numbers USING numberID=10 TO test_user;

CREATE user test_user_admin;
GRANT test_role TO test_user_admin;
CREATE ROW POLICY test_user_admin ON numbers USING 1 TO test_user_admin;
