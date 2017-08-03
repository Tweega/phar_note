defmodule PharNote.Router do
  use PharNote.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PharNote do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", PharNote do
    pipe_through :api

    #Users
    get "/users", UserController, :index
    get "/users/:id", UserController, :show
    post "/users", UserController, :create
    put "/users/:id", UserController, :update
    delete "/users/:id", UserController, :delete

    #user roles
    get "/roles", RoleController, :index
    get "/roledata", RoleController, :role_data
    get "/roles/:id", RoleController, :show
    post "/roles", RoleController, :create
    put "/roles/:id", RoleController, :update
    delete "/roles/:id", RoleController, :delete

    #Equipment
    get "/equipment", EquipmentController, :index
    get "/equipment/refdata", EquipmentController, :ref_data
    get "/equipment/:id", UserController, :show
    post "/equipment", UserController, :create
    put "/equipment/:id", UserController, :update
    delete "/equipment/:id", UserController, :delete

    #EquipmentClass
    get "/equipmentclass", EquipmentClassesController, :index
    get "/equipmentclass/:id", UserController, :show
    post "/equipmentclass", EquipmentClassesController, :create
    put "/equipmentclass/:id", UserController, :update
    delete "/equipmentclass/:id", UserController, :delete

    #EquipmentPrecision
    get "/equipmentprecision", EquipmentPrecisionController, :index
    get "/equipmentprecision/:id", UserController, :show
    post "/equipmentprecision", EquipmentPrecisionController, :create
    put "/equipmentprecision/:id", UserController, :update
    delete "/equipmentprecision/:id", UserController, :delete

    resources "/location", LocationController, only: [:index]
    resources "/product", ProductController, only: [:index]
    resources "/productstrength", ProductStrengthController, only: [:index]

    resources "/campaigns", CampaignController, only: [:index]
    #resources "/requirement", RequirementController, only: [:index]
    #resources "/fulfilment", FulfilmentController, only: [:index]


    #test
    get "/test", TestController, :index

  end
end
