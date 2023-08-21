alias Zaqueu.Financial

# Create Categories
Financial.create_category_if_not_exists(%{description: "Carro"})
Financial.create_category_if_not_exists(%{description: "Restaurante"})
Financial.create_category_if_not_exists(%{description: "Saúde"})
Financial.create_category_if_not_exists(%{description: "Transporte"})
Financial.create_category_if_not_exists(%{description: "Supermercado"})
Financial.create_category_if_not_exists(%{description: "Serviços"})
Financial.create_category_if_not_exists(%{description: "Compras"})
Financial.create_category_if_not_exists(%{description: "Outros"})

# Create Kinds
Financial.create_kind_if_not_exists(%{description: "Cartão de Crédito"})
Financial.create_kind_if_not_exists(%{description: "Transferência Bancária"})
Financial.create_kind_if_not_exists(%{description: "Recorrente"})
Financial.create_kind_if_not_exists(%{description: "Débito"})
Financial.create_kind_if_not_exists(%{description: "Dinheiro"})

# Create Banks
Financial.create_bank_if_not_exists(%{code: "077", name: "Banco Itaú"})
