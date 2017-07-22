defmodule PharNote.CampaignController do
  use PharNote.Web, :controller
  require Logger

  def index(conn, _params) do
    campaign = index_data()
            #  |> Enum.map(fn(campaign) -> cleanup(campaign) end)
    json conn, campaign
  end

  def index_data() do
    data = PharNote.Campaign
     |> PharNote.Campaign.campaign_details     
     |> Repo.all

  #  strip_equip(data)
  #|> PharNote.Campaign.sorted

  end



  def show(conn, %{"id" => id}) do
    campaign = Repo.get(PharNote.Campaign, String.to_integer(id))

    json conn_with_status(conn, campaign), campaign
  end

  # def create(conn, params) do
  #
  #   #params = %{"email" => "ll", "first_name" => "luna", "last_name" => "lovegood", "photo_url" => "luna.jpg", "campaign_roles" => "12,13, 15"}
  #
  #   changeset = PharNote.Campaign.changeset_new(%PharNote.Campaign{}, params)
  #   case Repo.insert(changeset) do
  #     {:ok, campaign} ->
  #       cs = PharNote.Campaign.changesetx(campaign, params)
  #       case Repo.update(cs) do
  #         {:ok, newCampaign} ->
  #           #strip out the campaign_roles field - either that or do a cast_assoc on it
  #           u2 = %PharNote.Campaign{ newCampaign | campaign_roles: []}  #or nil
  #           json conn |> put_status(:created), u2 #why not just return campaign
  #         {:error, _changeset} ->
  #           json conn |> put_status(:bad_request), %{errors: ["unable to create campaign 1"]}
  #       end
  #     {:error, _changeset} ->
  #       json conn |> put_status(:bad_request), %{errors: ["unable to create campaign"]}
  #   end
  # end
  #
  # def update(conn, %{"id" => id} = params) do
  #   campaign = Repo.get(PharNote.Campaign, id)
  #   if campaign do
  #     perform_update(conn, campaign, params)
  #   else
  #     json conn |> put_status(:not_found), %{errors:   ["invalid campaign"]}
  #   end
  # end
  #
  # defp perform_update(conn, campaign, params) do
  #   changeset = PharNote.Campaign.changesetx(campaign, params)
  #   case Repo.update(changeset) do
  #     {:ok, campaign} ->
  #       u2 = hd(strip_role_campaign([campaign]))
  #       json conn |> put_status(:ok), u2
  #     {:error, _result} ->
  #       json conn |> put_status(:bad_request), %{errors: ["unable to update campaign"]}
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   campaign = Repo.get(PharNote.Campaign, id)
  #   if campaign do
  #     Repo.delete(campaign)
  #     u2 = %PharNote.Campaign{ campaign | campaign_roles: []}  #or nil
  #     json conn |> put_status(:accepted), u2
  #   else
  #     json conn |> put_status(:not_found), %{errors: ["invalid campaign"]}
  #   end
  # end

  defp conn_with_status(conn, nil) do
    conn
      |> put_status(:not_found)
  end

  defp conn_with_status(conn, _) do
    conn
      |> put_status(:ok)
  end



#  defp cleanup(campaign) do
#    Map.drop(campaign, [:tickets, :group])
#  end


#an alternative architecture is to call on the view layer, which is done
#in PhoenixAndElm

#render conn, page: page

#where the render function calls down to the view layer


end
