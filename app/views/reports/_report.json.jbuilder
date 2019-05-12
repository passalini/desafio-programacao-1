json.extract! report, :id, :name, :created_at, :updated_at
json.url report_url(report, format: :json)
