defmodule PharNote.TestController do
  use PharNote.Web, :controller
  require Logger
  require Phoenix.Endpoint

  import Plug.Conn

  def index(conn, _params) do
    # tests = index_data()
    #         #  |> Enum.map(fn(test) -> cleanup(test) end)
    # j = json conn, tests
    # Logger.debug fn -> inspect(tests) end

     #json conn, "{\"key\":\"this will be a value\"}"
    # data = "{\"key\":\"this will be a value\"}"

     #now I want to get some json from postgrex db
     #i will need to be able to connect
   #send_resp(conn, conn.status || 200, "application/json", encoder.encode_to_iodata!(data))

#I do need to be able to get the database out of config
   #{:ok, pid} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "phar_note_dev")
   pida = Process.whereis(Project.Postgres)
   pid =
       case pida do
            nil ->
                IO.inspect("pida is nil")
                {:ok, p} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "phar_note_dev", types: PharNote.PostgrexTypes)
                Process.register p, PharNote.Postgres
                p
            _ ->
                pida
        end

   Logger.debug  fn -> inspect(pid) end




   #{:ok, pid} = Postgrex.Connection.start_link(database: "postgres", extensions: [Extensions.JSON])

    #qry = "SELECT first_name, last_name FROM users"
    qry = "select user_roles_json_text as data from user_roles_json_text()"
    data = Postgrex.query!(PharNote.Postgres, qry, [])
    jData = hd(hd(data.rows))
    Logger.debug  fn -> inspect(pid) end
    Logger.debug  fn -> inspect(jData) end
    send_resp(conn, conn.status || 200, "application/json", jData)
  end

    defp send_resp(conn, default_status, default_content_type, body) do
      conn
      |> ensure_resp_content_type(default_content_type)
      |> send_resp(conn.status || default_status, body)
    end

    defp ensure_resp_content_type(%{resp_headers: resp_headers} = conn, content_type) do
      if List.keyfind(resp_headers, "content-type", 0) do
        conn
      else
        content_type = content_type <> "; charset=utf-8"
        %{conn | resp_headers: [{"content-type", content_type}|resp_headers]}
      end
    end

  def index_data() do
    data = PharNote.User
     |> PharNote.User.with_roles
     |> PharNote.User.sorted
     |> Repo.all

    strip_role_users(data)

  end

  def strip_role_users(users) do
    Enum.map(users, fn u ->
      #what I want back is a new list of roles
      new_roles = Enum.map(u.roles, fn r ->
        %PharNote.Role{ r | users: []}
      end)
      %PharNote.User{u | roles: new_roles}
    end)
  end


end
