-- Access control

-- Add role on cluser
CREATE ROLE test_role ON CLUSTER 'shardedreplicated'

-- GRANT SELECT on tabe to a role on cluster
GRANT SELECT ON numbers TO test_role ON CLUSTER 'shardedreplicated'
GRANT SELECT ON numbers_dist TO test_role ON CLUSTER 'shardedreplicated'

-- Add new user and add to a new role on cluster
CREATE user test_user ON CLUSTER 'shardedreplicated'
GRANT test_role TO test_user ON CLUSTER 'shardedreplicated'

-- Add row policies to filter rows based on the user on cluster
CREATE ROW POLICY numbers_test_user ON numbers_dist USING numberID=10 TO test_user ON CLUSTER 'shardedreplicated'
CREATE ROW POLICY numbers_test_user ON numbers USING numberID=10 TO test_user ON CLUSTER 'shardedreplicated'

/*
Afer create the first ROW POLICY for a certain table all other users
will not be able to search on it, not even the defaut.

If we want a user with full access to the table we need to create one
or set a new ROW POLICY as below
*/

-- Add user with full access to the table on cluster
CREATE user test_user_admin ON CLUSTER 'shardedreplicated'

-- Add new user to the same previous role on lcuster
GRANT test_role TO test_user_admin ON CLUSTER 'shardedreplicated'

-- Add row policy allowing full access to the table on cluster
CREATE ROW POLICY test_user_admin ON numbers USING 1 TO test_user_admin ON CLUSTER 'shardedreplicated';
