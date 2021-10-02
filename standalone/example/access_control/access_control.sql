-- Access control

-- Add role
CREATE ROLE test_role;

-- Grant SELECT on table ro role
GRANT SELECT ON numbers TO test_role;
GRANT SELECT ON numbers_dist TO test_role;

-- Add new user and add to role
CREATE user test_user;
GRANT test_role TO test_user;

-- Add row policies to filter rows based on the user
CREATE ROW POLICY numbers_test_user ON numbers_dist USING numberID=10 TO test_user;
CREATE ROW POLICY numbers_test_user ON numbers USING numberID=10 TO test_user;

/*
Afer create the first ROW POLICY for a certain table all other users
will not be able to search on it, not even the defaut.

If we want a user with full access to the table we need to create one
or set a new ROW POLICY as below
*/

-- Add user with full access to the table
CREATE user test_user_admin;

-- Add new user to the same previous role
GRANT test_role TO test_user_admin;

-- Add row policy allowing full access to the table
CREATE ROW POLICY test_user_admin ON numbers USING 1 TO test_user_admin;
