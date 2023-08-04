# source from: https://gist.github.com/marckohlbrugge/7af366e82d7efc630fe68f4d21bfd360

class WIP
  def initialize(api_key:)
    @api_key = api_key
  end

  def create_todo(attributes = {})
    query = %{
      mutation createTodo {
        createTodo(input: {#{serialize_attributes(attributes)}}) {
          id
          body
          completed_at
        }
      }
    }
    json = make_request query
    json["data"]["createTodo"]
  end

  def complete_todo(todo_id)
    query = %{
      mutation completeTodo {
        completeTodo(id: #{todo_id}) {
          id
          body
          completed_at
        }
      }
    }
    json = make_request query
    json["data"]["completeTodo"]
  end

  private

  def make_request(query)
    uri = URI.parse("https://wip.co/graphql")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    header = {
      "Authorization": "bearer #{@api_key}",
      "Content-Type": 'application/json'
    }
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = { query: query }.to_json

    # Send the request
    response = http.request(request)

    json = JSON.parse(response.body)
    if json.has_key? "errors"
      raise json["errors"].first["message"]
    end
    json
  end

  def serialize_attributes(attributes)
    attributes.collect do |k,v|
      "#{k}: \"#{v}\""
    end.join(", ")
  end
end