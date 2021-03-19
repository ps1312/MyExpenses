# MyFinances

App made with Swift and UIKit to practice various topics:

- TDD
- Clean code
- Modular architecture
- UI creation in iOS

The goal in the end is to have an iOS application that help me to do one simple task:
**Track my expenses**

As for the technical side, the application should be made with _decoupled_ modules, in other words, the system should be _extendable_, _flexible_ and _plataform agnostic_ to promove reusability of code.

---

### The Expense API response
The expected API object used for expenses retrieval will be:

```json
{
    "expenses": [
        {
            "id": "a UUID",
            "title": "a title",
            "amount": 16.99,
            "created_at": "2021-03-19T00:11:00+00:00"
        },
        {
            "id": "another UUID",
            "title": "another title",
            "amount": 0.99,
            "created_at": "2021-03-19T00:11:00+00:00"
        },
        {
            "id": "even another UUID",
            "title": "even another title",
            "amount": 1024.00,
            "created_at": "2021-03-19T00:11:00+00:00"
        },
    ]
}
```
