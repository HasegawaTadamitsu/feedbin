services = []

services << SupportedSharingService.new(
  service_id: 'pocket',
  label: 'Pocket',
  requires_auth: true,
  type: 'oauth'
)

services << SupportedSharingService.new(
  service_id: 'readability',
  label: 'Readability',
  requires_auth: true,
  type: 'xauth'
)

services << SupportedSharingService.new(
  service_id: 'instapaper',
  label: 'Instapaper',
  requires_auth: true,
  type: 'xauth'
)

services << SupportedSharingService.new(
  service_id: 'email',
  label: 'Email',
  requires_auth: false,
  type: 'email'
)


Feedbin::Application.config.supported_services = services.sort_by {|supported_service| supported_service.service_id}