json.array!(@admin_suppliers) do |admin_supplier|
  json.extract! admin_supplier, :id
  json.url admin_supplier_url(admin_supplier, format: :json)
end
