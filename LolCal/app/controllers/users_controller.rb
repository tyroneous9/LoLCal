class UsersController < ApplicationController
    @builds = Build.all
    @builds = Build.includes(:items).all
end
