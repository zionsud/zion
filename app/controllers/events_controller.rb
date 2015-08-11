class EventsController < ApplicationController
  before_action :authenticate_user, :must_have_person_if_logged_in, :must_be_active

  def index
    @events = Event.all.order(:name)
  end

  def show
    @event = Event.find(params[:id])
  end

  def destroy
    @event = Event.find(params[:id])
    notice = nil
    alert = nil
    if(@event.destroy!)
      notice = "Evento excluído com sucesso!"
    else
      alert = "Evento não pôde ser excluído, contate o administrador!"
    end
    redirect_to :back, notice: notice, alert: alert
  end

  def enroll
    event = Event.find(params[:event_id])
    user = User.find(params[:user_id])
    notice = nil
    alert = nil
    if(Time.now < event.end_datetime)
      begin
        event.users << user
        event.save!
        user.save!
        notice = "Inscrição realizada com sucesso!"
      rescue ActiveRecord::RecordNotFound
        alert = "Usuário ou Evento não encontrados"
      rescue ActiveRecord::RecordNotUnique
        alert = "Usuário já inscrito no evento!"
      rescue
        alert = "Erro na inscrição. Contate um administrador!"
      end
    else
      alert = "Inscrições não são mais permitidas neste evento!"
    end
    redirect_to :back, notice: notice, alert: alert
  end
end
