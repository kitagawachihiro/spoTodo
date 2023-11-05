class AdminUser < ApplicationRecord
    enum role: { general: 0, admin: 1 }
end
