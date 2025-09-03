# app/controllers/emails_controller.rb
class EmailsController < ApplicationController
  before_action :set_email, only: [ :show, :update, :destroy ]

  def index
    @emails = Email.order(created_at: :desc)
  end

  def show
    # Marquer lu à l’ouverture (BDD + maj visuelle via Hotwire)
    @email.update(read: true) unless @email.read?
  end

  def create
    @email = Email.create!(
      object: Faker::Lorem.sentence(word_count: 5),
      body:   Faker::Lorem.paragraphs(number: 3).join("\n\n")
    )

    respond_to do |format|
      format.turbo_stream   # -> app/views/emails/create.turbo_stream.erb
      format.html { redirect_to emails_path, notice: "Email reçu." }
    end
  end

  # PATCH/PUT /emails/:id
  def update
    if @email.update(email_params)
      respond_to do |format|
        format.turbo_stream { head :ok }             # pas de reload, Hotwire s’en charge
        format.html { redirect_to emails_path, notice: "Email mis à jour." }
      end
    else
      respond_to do |format|
        format.html { redirect_to emails_path, alert: "Mise à jour impossible." }
      end
    end
  end

  def destroy
    @email.destroy
    respond_to do |format|
      format.turbo_stream   # -> app/views/emails/destroy.turbo_stream.erb
      format.html { redirect_to emails_path, notice: "Email supprimé." }
    end
  end

  private

  def set_email
    @email = Email.find(params[:id])
  end

  def email_params
    # Pendant le debug tu peux utiliser: params.fetch(:email, {}).permit(:read)
    params.require(:email).permit(:read)
  end
end
