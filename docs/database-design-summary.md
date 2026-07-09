# Database Design Summary

This project models a university library system using conceptual, logical, and physical database design.

## Conceptual Design

The conceptual design identifies the main entities, relationships, and constraints for the library system. Key entities include Item, CopyOfItem, Member, Loan, HoldRequest, MemberType, Privilege, Collection, and NewItemRequest.

## Logical Design

The conceptual model was mapped into a relational schema. Superclass and subclass structures were converted into separate relational tables. Multi-valued attributes such as item authors and member phone numbers were separated into their own tables.

## Physical Design

The database was implemented in Microsoft SQL Server using T-SQL. The implementation includes primary keys, foreign keys, default values, constraints, sample data, triggers, and reporting queries.

## Skills Demonstrated

- Conceptual database design
- EER modelling
- Relational schema design
- Normalisation
- Microsoft SQL Server
- T-SQL scripting
- Primary and foreign key constraints
- Triggers
- Joins, aggregation, CTEs, and reporting queries
