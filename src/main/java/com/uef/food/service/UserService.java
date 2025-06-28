package com.uef.food.service;

import com.uef.food.model.User;
import com.uef.food.model.UserRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.List;

@Service
@Transactional
public class UserService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private RowMapper<User> userRowMapper = new RowMapper<User>() {
        @Override
        public User mapRow(ResultSet rs, int rowNum) throws SQLException {
            User user = new User();
            user.setId(rs.getLong("id"));
            user.setUsername(rs.getString("username"));
            user.setEmail(rs.getString("email"));
            user.setPassword(rs.getString("password"));

            // Handle full_name or fullname variations
            try {
                user.setFullName(rs.getString("full_name"));
            } catch (SQLException e) {
                try {
                    user.setFullName(rs.getString("fullname"));
                } catch (SQLException e2) {
                    user.setFullName("");
                }
            }

            // Handle optional fields safely
            try {
                user.setPhone(rs.getString("phone"));
            } catch (SQLException e) {
                user.setPhone("");
            }

            try {
                user.setAddress(rs.getString("address"));
            } catch (SQLException e) {
                user.setAddress("");
            }
            // Handle role
            try {
                String roleStr = rs.getString("role");
                if (roleStr != null) {
                    user.setRole(UserRole.valueOf(roleStr));
                } else {
                    user.setRole(UserRole.CUSTOMER);
                }
            } catch (SQLException e) {
                user.setRole(UserRole.CUSTOMER);
            }

            // Handle restaurant_id for RESTAURANT_STAFF
            try {
                Long restaurantId = rs.getLong("restaurant_id");
                if (!rs.wasNull()) {
                    user.setRestaurantId(restaurantId);
                }
            } catch (SQLException e) {
                // restaurant_id column doesn't exist or is null
                user.setRestaurantId(null);
            }

            // Handle is_active or active variations
            try {
                user.setActive(rs.getBoolean("is_active"));
            } catch (SQLException e) {
                try {
                    user.setActive(rs.getBoolean("active"));
                } catch (SQLException e2) {
                    try {
                        // Try as integer (1/0)
                        int activeInt = rs.getInt("is_active");
                        user.setActive(activeInt == 1);
                    } catch (SQLException e3) {
                        try {
                            int activeInt = rs.getInt("active");
                            user.setActive(activeInt == 1);
                        } catch (SQLException e4) {
                            // Default to active if column doesn't exist
                            user.setActive(true);
                        }
                    }
                }
            }

            // Handle timestamp columns safely
            try {
                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    user.setCreatedAt(createdAt);
                }
            } catch (SQLException e) {
                try {
                    Timestamp createdDate = rs.getTimestamp("created_date");
                    if (createdDate != null) {
                        user.setCreatedAt(createdDate);
                    }
                } catch (SQLException e2) {
                    try {
                        Timestamp createTime = rs.getTimestamp("create_time");
                        if (createTime != null) {
                            user.setCreatedAt(createTime);
                        }
                    } catch (SQLException e3) {
                        // No timestamp column found, set to current time
                        user.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                    }
                }
            }

            try {
                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    user.setUpdatedAt(updatedAt);
                }
            } catch (SQLException e) {
                try {
                    Timestamp updatedDate = rs.getTimestamp("updated_date");
                    if (updatedDate != null) {
                        user.setUpdatedAt(updatedDate);
                    }
                } catch (SQLException e2) {
                    try {
                        Timestamp updateTime = rs.getTimestamp("update_time");
                        if (updateTime != null) {
                            user.setUpdatedAt(updateTime);
                        }
                    } catch (SQLException e3) {
                        // Column doesn't exist, set to current time
                        user.setUpdatedAt(new Timestamp(System.currentTimeMillis()));
                    }
                }
            }

            return user;
        }
    };

    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        List<User> users = jdbcTemplate.query(sql, userRowMapper, username);
        return users.isEmpty() ? null : users.get(0);
    }

    public User authenticate(String username, String password) {
        User user = findByUsername(username);
        if (user != null && user.getPassword().equals(password) && user.isActive()) {
            return user;
        }
        return null;
    }

    public User findById(Long id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        List<User> users = jdbcTemplate.query(sql, userRowMapper, id);
        return users.isEmpty() ? null : users.get(0);
    }

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        List<User> users = jdbcTemplate.query(sql, userRowMapper, email);
        return users.isEmpty() ? null : users.get(0);
    }

    public List<User> findAll() {
        String sql = "SELECT * FROM users";
        return jdbcTemplate.query(sql, userRowMapper);
    }

    public List<User> findByRole(UserRole role) {
        String sql = "SELECT * FROM users WHERE role = ?";
        return jdbcTemplate.query(sql, userRowMapper, role.toString());
    }

    // Add efficient count method for reports
    public long countByRole(UserRole role) {
        try {
            String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
            Integer count = jdbcTemplate.queryForObject(sql, Integer.class, role.toString());
            return count != null ? count.longValue() : 0L;
        } catch (Exception e) {
            return 0L;
        }
    }

    public List<User> findStaffByRestaurant(Long restaurantId) {
        String sql = "SELECT * FROM users WHERE role = ? AND restaurant_id = ?";
        return jdbcTemplate.query(sql, userRowMapper, UserRole.RESTAURANT_STAFF.toString(), restaurantId);
    }

    public List<User> findUnassignedStaff() {
        String sql = "SELECT * FROM users WHERE role = ? AND (restaurant_id IS NULL OR restaurant_id = 0)";
        return jdbcTemplate.query(sql, userRowMapper, UserRole.RESTAURANT_STAFF.toString());
    }

    public User save(User user) {
        if (user.getId() == null) {
            return insert(user);
        } else {
            return update(user);
        }
    }

    private User insert(User user) {
        // Include restaurant_id for RESTAURANT_STAFF role
        String sql;
        if (user.getRestaurantId() != null) {
            sql = "INSERT INTO users (username, email, password, full_name, role, restaurant_id) VALUES (?, ?, ?, ?, ?, ?)";
        } else {
            sql = "INSERT INTO users (username, email, password, full_name, role) VALUES (?, ?, ?, ?, ?)";
        }

        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getRole().toString());
            if (user.getRestaurantId() != null) {
                ps.setLong(6, user.getRestaurantId());
            }
            return ps;
        }, keyHolder);

        if (keyHolder.getKey() != null) {
            user.setId(keyHolder.getKey().longValue());
        }
        return user;
    }

    private User update(User user) {
        // Include restaurant_id in the update
        String sql = "UPDATE users SET username=?, email=?, password=?, full_name=?, role=?, restaurant_id=? WHERE id=?";
        jdbcTemplate.update(sql,
                user.getUsername(),
                user.getEmail(),
                user.getPassword(),
                user.getFullName(),
                user.getRole().toString(),
                user.getRestaurantId(),
                user.getId()
        );
        return user;
    }

    public void delete(Long id) {
        String sql = "DELETE FROM users WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }

    public boolean isUsernameExists(String username) {
        return findByUsername(username) != null;
    }

    public boolean isEmailExists(String email) {
        return findByEmail(email) != null;
    }

    public User register(String username, String email, String password, String fullName, UserRole role) {
        if (isUsernameExists(username) || isEmailExists(email)) {
            return null;
        }

        User user = new User(username, email, password, fullName, role);
        return save(user);
    }

    public void updateProfile(Long userId, String fullName, String phone, String address) {
        // Update user profile with full name, phone, and address
        String sql = "UPDATE users SET full_name=?, phone=?, address=? WHERE id=?";
        jdbcTemplate.update(sql, fullName, phone, address, userId);
    }

    public List<User> findRecentUsers(int limit) {
        String sql = "SELECT TOP " + limit + " * FROM users ORDER BY id DESC";
        return jdbcTemplate.query(sql, userRowMapper);
    }

    public List<User> findRecentOrders(int limit) {
        // Placeholder method for compatibility
        return findRecentUsers(limit);
    }
}
