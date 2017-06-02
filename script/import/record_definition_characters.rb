# -*- coding: utf-8 -*-
DefinitionCharacter.connection.execute 'alter table definition_characters disable keys'
DefinitionCharacter.where(:active => false).delete_all

sql = nil
i = 0
Definition.all.each do |definition|
  (definition.characters_simplified+definition.characters_traditional).split(//).uniq.each do |character|
    if !sql
      sql = "insert into definition_characters (definition_id,`character`) values "
    else
      sql += ","
    end
    
    sql += "(#{definition.id},'#{character}')"
    i += 1
  end

  if sql.length > 10000
    Definition.connection.execute sql
    i.to_s.length.times { print "" }
    print i.to_s
    STDOUT.flush
    sql = nil
  end
end

if sql
  Definition.connection.execute(sql)
end

DefinitionCharacter.connection.execute "update definition_characters set active = !active"
DefinitionCharacter.where(:active => false).delete_all
DefinitionCharacter.connection.execute "alter table definition_characters enable keys"
