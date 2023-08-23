class UsersController < ApplicationController

def edit;end

def update
    binding.pry
    current_user.update(distance: params[:distance])
end

end
