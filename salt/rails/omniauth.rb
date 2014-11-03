OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "{{ salt['pillar.get']('master:oauth:google:client_id','300435512582-kpu37jkjpg6j3nls62h2iq0cn1k7qsj1.apps.googleusercontent.com') }}", "{{ salt['pillar.get']('master:oauth:google:client_secret','nyomOuuQSOuHxdcoYdKi_Gkl') }}", {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}, prompt: "select_account",image_aspect_ratio: "square", image_size: 40}
end
