class WelcomeController < ApplicationController
  def index
    @ponies = Pony.all
  end

  def alicorns
    @ponies = Pony.where(kind: 'Alicorn')
    render :index
  end

  def unicorns
    @ponies = Pony.where(kind: 'Unicorn')
    render :index
  end

  def ponies
    @ponies = Pony.where(kind: 'Pony')
    render :index
  end

  def pegasi
    @ponies = Pony.where(kind: 'Pegasus')
    render :index
  end

  def dragons
    @ponies = Pony.where(kind: 'Dragon')
    render :index
  end

  def zebras
    @ponies = Pony.where(kind: 'Zebra')
    render :index
  end
end
