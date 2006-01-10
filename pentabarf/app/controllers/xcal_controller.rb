class XcalController < ApplicationController
  before_filter :authorize, :check_permission
  after_filter :compress
  
  def conference
    @conference = Momomoto::Conference.find({:conference_id => params[:id]})
    @rooms = Momomoto::View_room.find({:conference_id=>@current_conference_id, :language_id=>@current_language_id})
    @events = Momomoto::View_schedule_event.find({:conference_id => @conference.conference_id, :translated_id => @current_language_id})
    @timezone = 'Europe/Berlin'
    @response.headers['Content-Type'] = 'application/calendar+xml'   
    @response.headers['Content-Disposition'] = "attachment; filename=\"#{@conference.acronym}.xcs\""

  end
  
  protected

  def check_permission
    #redirect_to :action => :meditation if params[:action] != 'meditation'
    if @user.permission?('pentabarf_login') || params[:action] == 'meditation'
      @preferences = @user.preferences
      @current_conference_id = @preferences[:current_conference_id]
      @current_language_id = @preferences[:current_language_id]
    else
      redirect_to( :action => :meditation )
      false
    end
  end

end
