require '_aws'

class AwsIamRole < Inspec.resource(1)
  name 'aws_iam_role'
  desc 'Verifies settings for an IAM Role'
  example "
    describe aws_iam_role('my-role') do
      it { should exist }
    end
  "

  include AwsResourceMixin
  attr_reader :role_name, :description

  def inline_policies
    return [] unless @exists
    AwsIamRole::BackendFactory.create.list_role_policies(role_name: role_name).policy_names
  end

  def attached_policies
    return [] unless @exists
    AwsIamRole::BackendFactory.create.list_attached_role_policies(role_name: role_name).attached_policies.map(&:policy_name)
  end

  def inline_policy_document
    return InlinePolicyDocumentFilter.new({}) unless @exists
    documents = []
    backend = AwsIamRole::BackendFactory.create

    inline_policies.each do |policy|
      policy_data = URI.unescape(backend.get_role_policy({
      role_name: role_name,
      policy_name: policy,
      }).policy_document)

      document = JSON.parse(policy_data,:symbolize_names => true)[:Statement]

      document.each do |item|
        item[:Policy] = policy
      end
      documents << document
    end
    InlinePolicyDocumentFilter.new(documents.flatten)
  end

  def attached_policy_document
    return AttachedPolicyDocumentFilter.new({}) unless @exists
  end

  private

  def validate_params(raw_params)
    validated_params = check_resource_param_names(
      raw_params: raw_params,
      allowed_params: [:role_name],
      allowed_scalar_name: :role_name,
      allowed_scalar_type: String,
    )
    if validated_params.empty?
      raise ArgumentError, 'You must provide a role_name to aws_iam_role.'
    end
    validated_params
  end

  def fetch_from_aws
    role_info = nil
    begin
      role_info = AwsIamRole::BackendFactory.create.get_role(role_name: role_name)
    rescue Aws::IAM::Errors::NoSuchEntity
      @exists = false
      return
    end
    @exists = true
    @description = role_info.role.description
  end

  # Uses the SDK API to really talk to AWS
  class Backend
    class AwsClientApi
      BackendFactory.set_default_backend(self)
      def get_role(query)
        AWSConnection.new.iam_client.get_role(query)
      end

      def list_role_policies(query)
        AWSConnection.new.iam_client.list_role_policies(query)
      end
      
      def list_attached_role_policies(query)
        AWSConnection.new.iam_client.list_attached_role_policies(query)
      end

      def get_role_policy(query)
        AWSConnection.new.iam_client.get_role_policy(query)
      end

      def get_policy_version(criteria)
        AWSConnection.new.iam_client.get_policy_version(query)
      end
    end
  end
end

class InlinePolicyDocumentFilter
  filter = FilterTable.create
  filter.add_accessor(:entries)
        .add_accessor(:where)
        .add(:exists?) { |x| !x.entries.empty? }
        .add(:policies, field: :Policy)
        .add(:effects, field: :Effect)
        .add(:actions, field: :Action)
        .add(:resources, field: :Resource)
        .add(:conditions, field: :Condition)
        .add(:sids, field: :Sid)
        .add(:principals, field: :Principal)
  filter.connect(self, :document)

  attr_reader :document
  def initialize(document)
    @document = document
  end
end

class AttachedPolicyDocumentFilter
  filter = FilterTable.create
  filter.add_accessor(:entries)
        .add_accessor(:where)
        .add(:exists?) { |x| !x.entries.empty? }
        .add(:policies, field: :Policy)
        .add(:effects, field: :Effect)
        .add(:actions, field: :Action)
        .add(:resources, field: :Resource)
        .add(:conditions, field: :Condition)
        .add(:sids, field: :Sid)
        .add(:principals, field: :Principal)
  filter.connect(self, :document)

  attr_reader :document
  def initialize(document)
    @document = document
  end
end
