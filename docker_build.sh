bundle install
rake db:migrate RAILS_ENV=production DATABASE_URL=mysql2://webstore:odghotulkPX0VFsO@10.144.63.65/webstore_production
rake assets:precompile RAILS_ENV=production DATABASE_URL=mysql2://webstore:odghotulkPX0VFsO@10.144.63.65/webstore_production
docker build -t tenhs .
