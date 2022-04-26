# Examples:
#
# -- associations -----------------------------------------
#
# 1)  it_behaves_like "belongs_to", :source
# 2)  it_behaves_like "has_many", { associations: :articles }
#     it_behaves_like "has_many", { associations: :articles, dependent_destroy: true }
#
# -- validations -----------------------------------------
#
# 1) it_behaves_like "validates_presence_of", :title
# 2) it_behaves_like "validates_uniqueness_of", :title

shared_examples_for "validates_uniqueness_of" do |field|
  let(:described_class_sym)  { described_class.to_s.downcase.to_sym }
  let(:existed)              { create(described_class_sym) }
  let(:factory_model)        { build(described_class_sym) }

  context "#{field.to_s} unique" do
    it 'is valid' do
      expect(factory_model).to be_valid
    end
  end

  context "#{field.to_s} not unique" do
    it "is not valid" do
      factory_model.send("#{field.to_s}=", existed.send(field))
      expect(factory_model).not_to be_valid
    end
  end
end

shared_examples_for "validates_presence_of" do |field|
  let(:described_class_sym)  { described_class.to_s.downcase.to_sym }
  let(:factory_model)        { build(described_class_sym) }

  context "#{field.to_s} maintained" do
    it 'is valid' do
      expect(factory_model).to be_valid
    end
  end

  context "#{field.to_s} not maintained" do
    it "is not valid" do
      factory_model.send("#{field.to_s}=", nil)
      expect(factory_model).not_to be_valid
    end
  end
end

shared_examples_for "belongs_to" do |association|
  let(:described_class_sym)  { described_class.to_s.downcase.to_sym }
  let(:association_class)    { eval(association.to_s.capitalize) }  
  let!(:factory_model)       { create(described_class_sym) }

  it "belongs_to #{association.to_s}" do
    expect(factory_model.send(association)).to be_instance_of(association_class)
  end
end

shared_examples_for "has_many" do |params|
  let(:associations)          { params[:associations] }
  let(:described_class_sym)   { described_class.to_s.downcase.to_sym }
  let(:associations_sym)      { associations.to_s.singularize.to_sym }
  let(:associations_class)    { eval(associations.to_s.singularize.capitalize) }
  let!(:factory_model)         { create(described_class_sym) }
  let!(:factory_associations)  { create_list(associations_sym, 2, described_class_sym => factory_model) }

  it "has many #{params[:associations].to_s}" do
      expect(factory_associations.map(&:class).uniq)
        .to match_array([associations_class])
  end

  if params[:dependent_destroy]
    it "destroys associated #{params[:associations].to_s}" do
      expect{ factory_model.destroy }
        .to change(associations_class, :count).by( -factory_associations.size )
    end
  end
end