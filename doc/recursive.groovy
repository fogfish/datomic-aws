import datomic.Peer

//
// connect to datomic
uri = "datomic:ddb-local://localhost:8000/datomic/test"
Peer.createDatabase(uri)
c = Peer.connect(uri)

//
// define attributes
c.transact([[
   ':db/id': Peer.tempid(':db.part/db'),
   ':db/ident': ':foaf/name',
   ':db/valueType': ':db.type/string',
   ':db/cardinality': ':db.cardinality/one',
   ':db.install/_attribute': ':db.part/db'
]])

c.transact([[
   ':db/id': Peer.tempid(':db.part/db'),
   ':db/ident': ':foaf/parent',
   ':db/valueType': ':db.type/string',
   ':db/cardinality': ':db.cardinality/many',
   ':db.install/_attribute': ':db.part/db'
]])

//
// define recursive data
c.transact([[
   ':db/id': "#db/id[:stages -1]",
   ':foaf/name': "ann",
   ':foaf/parent': "dorothy"
]])

c.transact([[
   ':db/id': "#db/id[:stages -1]",
   ':foaf/name': "ann",
   ':foaf/parent': "hilary"
]])

c.transact([[
   ':db/id': "#db/id[:stages -1]",
   ':foaf/name': "bertrand",
   ':foaf/parent': "dorothy"
]])

c.transact([[
   ':db/id': "#db/id[:stages -1]",
   ':foaf/name': "charles",
   ':foaf/parent': "evelyn"
]])

c.transact([[
   ':db/id': "#db/id[:stages -1]",
   ':foaf/name': "dorothy",
   ':foaf/parent': "george"
]])

c.transact([[
   ':db/id': "#db/id[:stages -1]",
   ':foaf/name': "evelyn",
   ':foaf/parent': "george"
]])

c.transact([[
   ':db/id': "#db/id[:stages -1]",
   ':foaf/name': "fred"
]])

c.transact([[
   ':db/id': "#db/id[:stages -1]",
   ':foaf/name': "george"
]])

c.transact([[
   ':db/id': "#db/id[:stages -1]",
   ':foaf/name': "hilary"
]])


//
// query recursive data
rules = '''[
   [[sgc, ?x, ?y]
      [?e :foaf/name   ?x]
      [?e :foaf/name   ?y]
   ]
   [[sgc, ?x, ?y]
      [?e :foaf/name   ?x]
      [?e :foaf/parent ?a]
      (sgc ?a ?b)
      [?d :foaf/parent ?b]
      [?d :foaf/name ?y]
   ]
]'''
Peer.query('[:find ?x ?y :in $ % :where (sgc ?x ?y)[(!= ?x ?y)]]', c.db(), rules)

