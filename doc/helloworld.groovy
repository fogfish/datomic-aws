import datomic.Peer

//
// connect to datomic
uri = "datomic:ddb-local://localhost:8000/datomic/test"
Peer.createDatabase(uri)
c = Peer.connect(uri)

//
// define partition
c.transact([[
   ':db/id': "stages", 
   ':db/ident': ':stages',
   ':db.install/_partition': ':db.part/db'
]])

//
// define attributes
c.transact([[
   ':db/id': Peer.tempid(':db.part/db'),
   ':db/ident': ':rdf/id',
   ':db/valueType': ':db.type/string',
   ':db/unique': ':db.unique/identity',
   ':db/cardinality': ':db.cardinality/one',
   ':db.install/_attribute': ':db.part/db'
]])

c.transact([[
   ':db/id': Peer.tempid(':db.part/db'),
   ':db/ident': ':dc/title',
   ':db/valueType': ':db.type/string',
   ':db/cardinality': ':db.cardinality/many',
   ':db.install/_attribute': ':db.part/db'
]])

//
// inject datom
c.transact([[
   ':db/id': "#db/id[:stages -1]",
   ':rdf/id': "zk:abc",
   ':dc/title': "test abc"
]])

c.transact([[
   ':db/id': "#db/id[:stages -1]",
   ':rdf/id': "zk:def",
   ':dc/title': "test def"
]])

c.transact([[
   ':db/id': "#db/id[:stages -1]",
   ':rdf/id': "zk:def",
   ':dc/title': "test def subtitle"
]])

Peer.query('[:find ?id ?title :where [?e :rdf/id ?id] [?e :dc/title ?title]]', c.db())

//
// query with rules
rules = '''[
   [[tuple, ?x, ?y]
      [?e :rdf/id   ?x]
      [?e :dc/title ?y]]
]'''
Peer.query('[:find ?id ?title :in $ % :where (tuple ?id ?title)]', c.db(), rules)


