# Distributed Library System

KafkaとCQRSを活用した分散システムとして設計された図書館管理プラットフォーム。マイクロサービス間の疎結合とスケーラビリティを重視し、在庫・貸出・認証・通知などを独立して管理。

A distributed library system built with Kafka and CQRS, focusing on scalability, loosely coupled microservices, and
production-ready backend architecture.

## 🗺️ Project Diagram

![mermaid-diagram](docs/images/mermaid-diagram-2026-04-09-193314.png)

---

### 🧠 Architecture Summary / 概要

Event-driven distributed system using Kafka and CQRS.
Decoupled microservices communicate asynchronously via an event backbone, ensuring scalability, resilience, and eventual
consistency.

KafkaとCQRSを活用したイベント駆動型分散システム。  
マイクロサービス間は非同期イベントで疎結合に連携し、スケーラビリティと耐障害性を実現。

---

### ⚙️ Key Design Decisions / 設計上のポイント

- CQRS pattern to separate read/write concerns  
  → 読み取りと書き込みを分離するCQRSを採用


- Event-driven architecture with Kafka  
  → Kafkaによるイベント駆動設計


- Polyglot microservices (Java, Node.js, PHP)  
  → ドメインごとに最適な技術スタックを選択


- API Gateway (OpenResty + Lua) for centralized routing and authentication  
  → API Gatewayによるルーティングと認証の一元化

---

### 🎯 Why this architecture? / なぜこの構成か

This architecture isolates heavy processing (analytics, notifications) from user-facing services, ensuring low latency
and high scalability.

重い処理（分析・通知）を分離することで、ユーザー向けサービスの低遅延と高スケーラビリティを実現。

Inspired by real-world distributed systems used in fintech and banking environments.

金融・Fintechシステムの設計思想を参考に構築。

---

### 🧩 System Architecture / システム構成

#### 1. Frontend & Routing Layer / フロントエンド・ルーティング層

- Frontend App (Vue.js)  
  → Provides UI and user experience  
  → UIとユーザー体験を提供


- API Gateway (OpenResty + Lua)  
  → Single entry point with routing, authentication, and filtering  
  → 認証・ルーティング・フィルタリングを担当する単一エントリーポイント

---

#### 2. Event Producers (Command Side) / コマンドサイド（書き込み）

- Borrow Service (Spring Boot)  
  → Handles borrow/return logic  
  → 貸出・返却ロジックを管理


- Auth Service (Laravel)  
  → Handles authentication and user events  
  → 認証およびユーザーイベントを管理

➡️ These services publish events to Kafka instead of directly writing to other services.

➡️ 他サービスへ直接書き込まず、Kafkaへイベントを発行

---

#### 3. Event Backbone / イベント基盤

- Kafka Cluster (KRaft Mode)  
  → Central event bus enabling asynchronous communication  
  → 非同期通信を実現する中枢イベントバス


- Ensures event persistence, replayability, and eventual consistency  
  → イベントの永続化・再処理・結果整合性を保証

---

#### 4. Consumers & Services (Query Side) / クエリ・分析サイド

- Records Service  
  → CQRS read model for fast queries  
  → 高速参照用のCQRSリードモデル


- Inventory Service  
  → Manages stock updates from events  
  → イベントベースで在庫を更新


- Analytics Service  
  → Processes events for rankings and analytics  
  → 分析・ランキング処理を担当


- MemberCard Service  
  → Handles user membership data  
  → 会員情報を管理


- Comments Service (Node.js)  
  → Handles user-generated content  
  → コメント管理

---

#### 5. Notification Workers / 通知ワーカー

- Notification Workers (Laravel)  
  → Consume events and send notifications asynchronously  
  → イベントを受信し非同期で通知を送信


- Prevents performance impact on core services  
  → コアサービスのパフォーマンス低下を防止

---

## 🔗 Services Overview / サービス一覧

- [library-app-ui](https://github.com/damouu/library-app-ui)  
  → Frontend application (Vue.js) interacting with backend services via API Gateway  
  → API Gatewayを通じてバックエンドと連携するフロントエンドアプリケーション（Vue.js）


- [library-app-auth](https://github.com/damouu/library-app-auth)  
  → Authentication & authorization service (Laravel, JWT, Redis cache)  
  → 認証・認可サービス（Laravel、JWT、Redisキャッシュ）


- [library-app-catalogue](https://github.com/damouu/library-app-catalogue)  
  → Book catalogue service (Spring Boot, PostgreSQL)  
  → 書籍カタログ管理サービス（Spring Boot、PostgreSQL）


- [library-app-comments](https://github.com/damouu/library-app-comments)  
  → Comments service (Node.js, MongoDB)  
  → コメント管理サービス（Node.js、MongoDB）


- [library-app-records](https://github.com/damouu/library-app-records)  
  → Read model service (CQRS) for user borrowing history  
  → ユーザー貸出履歴の参照用サービス（CQRSリードモデル）


- [library-app-borrow](https://github.com/damouu/library-app-borrow)  
  → Core business service handling borrow/return logic (Spring Boot, Kafka producer)  
  → 貸出・返却ロジックを担当するコアサービス（Spring Boot、Kafkaプロデューサー）


- [library-app-inventory](https://github.com/damouu/library-app-inventory)  
  → Inventory management service (Kafka consumer, stock updates)  
  → 在庫管理サービス（Kafkaコンシューマー、在庫更新処理）


- [library-app-analytics](https://github.com/damouu/library-app-analytics)  
  → Analytics & ranking service (event-driven processing)  
  → 分析・ランキングサービス（イベント駆動処理）


- [library-app-membercard](https://github.com/damouu/library-app-membercard)  
  → Membership & user card management service  
  → 会員・ユーザーカード管理サービス


- [library-app-notification](https://github.com/damouu/library-app-notification)  
  → Notification service (Kafka consumers, email dispatch)  
  → 通知サービス（Kafkaコンシューマー、メール送信）

---

### 🧱 Docker Compose Overview / 構成概要

The `docker-compose.yml` orchestrates the entire distributed system by defining all services, dependencies, and
infrastructure components.

この `docker-compose.yml` は、すべてのサービス・依存関係・インフラ構成を統合管理しています。

---

### 🔑 Key Components / 主要構成

- **Kafka (KRaft mode)**  
  → Central event streaming platform for asynchronous communication  
  → 非同期通信を担うイベント基盤


- **Microservices**  
  → Independent services (Spring Boot, Node.js, Laravel) communicating via events  
  → イベントを通じて連携するマイクロサービス群


- **Databases**  
  → PostgreSQL, MongoDB, Redis (per-service data ownership)  
  → サービスごとに分離されたデータ管理


- **API Gateway (OpenResty)**  
  → Centralized routing and authentication  
  → ルーティングと認証の一元化


- **Observability Stack**  
  → Prometheus, Grafana, Jaeger for monitoring and tracing  
  → 監視・トレーシング基盤

---

### ⚙️ Design Choices / 設計ポイント

- Each service has its own database (data isolation)  
  → サービスごとに独立したデータベース


- Kafka used as the event backbone (decoupling)  
  → Kafkaによる疎結合な通信


- Healthchecks & dependencies ensure proper startup order  
  → ヘルスチェックによる起動順制御


- Worker-based architecture for async tasks (notifications)  
  → 非同期処理をワーカーで分離

---

This setup reflects a production-like distributed system designed for scalability and resilience.

スケーラビリティと耐障害性を考慮した実務レベルの構成です。

---

## 🐳 Run Locally / ローカル実行

You can run the entire distributed system locally using Docker Compose.  
This setup simulates a production-like environment with Kafka, databases, and all microservices.

Docker Composeを使用して、Kafka・データベース・各マイクロサービスを含む分散システム全体をローカルで起動できます。実務に近い構成を再現しています。

---

### 🚀 Quick Start

```bash
git clone https://github.com/damouu/distributed-library-system.git
cd distributed-library-system
docker-compose up --build

```

---

## 🔄 Borrow Flow / 貸出処理フロー

This diagram illustrates the business flow when a user borrows a book.  
The request is processed by the Borrow Service, which validates the operation and publishes an event to Kafka.  
Other services then react asynchronously to update their respective domains.

この図は、ユーザーが本を借りる際の業務フローを示しています。  
リクエストはBorrow Serviceで処理され、検証後にKafkaへイベントが発行されます。  
その後、各サービスが非同期でイベントを処理し、それぞれのデータを更新します。

![mermaid-diagram](docs/images/mermaid-diagram-2026-04-16-115557.png)

---

## ⏳ Eventual Consistency Flow / 結果整合性フロー

This diagram illustrates how the system achieves eventual consistency using an event-driven architecture.  
When a user performs a borrow action, the system responds immediately while propagating changes asynchronously across
multiple services via Kafka.

この図は、イベント駆動アーキテクチャにおける結果整合性（Eventual Consistency）の仕組みを示しています。  
ユーザーが貸出操作を行うと、システムは即時にレスポンスを返し、その後Kafkaを通じて各サービスに非同期で変更が伝播されます。

![mermaid-diagram](docs/images/mermaid-diagram-2026-04-16-122110.png)


---

### 3. CI/CD Pipeline / 継続的インテグレーション・デリバリー

Each microservice implements its own CI/CD pipeline using GitHub Actions, ensuring consistency across a polyglot
architecture (Java, Node.js, PHP).

各マイクロサービスはGitHub ActionsによるCI/CDパイプラインを持ち、Java・Node.js・PHPのポリグロット構成でも一貫した品質を保証します。

---

#### ⚙️ Pipeline Features / パイプラインの特徴

- Automated unit and integration testing (Maven, PHPUnit, Jest)  
  → ユニットテスト・統合テストの自動実行


- Code quality enforcement (linting, validation)  
  → コード品質チェック（Lint・構文検証）


- Test coverage reporting (Codecov integration)  
  → テストカバレッジの可視化


- Secure secret injection (JWT keys, environment variables)  
  → シークレット管理（JWT鍵など）

---

#### 🧪 Test Quality / テスト品質

- Coverage tracking ensures critical business logic is tested  
  → 重要なビジネスロジックのカバレッジを確保


- Cyclomatic complexity is reduced through modular design and testable services  
  → 循環的複雑度を抑えた設計によりテスト容易性を向上


- Separation between unit and integration tests (Java services)  
  → ユニットテストと統合テストの分離

---

#### 🔄 Automation / 自動化

- Automatic Pull Request creation when tests pass  
  → テスト成功時にPRを自動作成


- Automatic issue creation when tests fail  
  → テスト失敗時にIssueを自動生成


- Integration with YouTrack for workflow management  
  → YouTrackとの連携によるタスク管理

---

#### 🚀 Continuous Delivery / 継続的デリバリー

- Docker images are automatically built and pushed  
  → Dockerイメージの自動ビルド・Push


- Each image is tagged using the Git commit SHA  
  → 各イメージはGitのコミットSHAでタグ付け


- The pipeline checks out the exact commit before building  
  → ビルド前に対象コミットを明示的にチェックアウト


- Enables reproducible builds and precise version tracking  
  → 再現可能なビルドと正確なバージョン管理を実現


- Allows safe rollback to any previous version in production  
  → 本番環境での安全なロールバックが可能

This approach ensures traceability between source code and deployed artifacts, a key requirement in production-grade
systems.

この仕組みにより、ソースコードとデプロイされた成果物のトレーサビリティが保証され、本番環境において重要な要件を満たします。

---

### 🎯 Outcome / 成果

This CI/CD system ensures high code quality, fast feedback loops, and production-ready builds across all services.

このCI/CDにより、高品質なコード、迅速なフィードバック、本番対応可能なビルドを実現しています。

---

## 🔍 Distributed Tracing with Jaeger / Jaegerによる分散トレーシング

To ensure full transparency and reliability in a distributed environment, the system implements OpenTelemetry-based
distributed tracing. This enables full visibility into the lifecycle of a request across multiple microservices and the
Kafka event backbone.

分散環境における透明性と信頼性を確保するため、本システムではOpenTelemetryによる分散トレーシングを実装しています。これにより、複数のマイクロサービスやKafkaイベント基盤をまたぐリクエストのライフサイクル全体を可視化できます。

---

### 🔍 Jaeger Trace — Borrow Request / Jaegerトレース：貸出リクエスト

This trace illustrates the end-to-end lifecycle of a borrow request across the distributed system, including synchronous
processing and asynchronous event propagation.

このトレースは、貸出リクエストがシステム全体をどのように流れるか（同期処理および非同期イベント伝播）を示しています。

![jaeger-trace-borrow](docs/images/jaeger-trace-borrow.png.png)

---

## 📌 Case Study: Borrow Action / ケーススタディ：貸出処理

The following trace (ID: `a982a5638069bbe89c869698dfea64b8`) illustrates a complete borrow request lifecycle.

以下のトレース（ID: `a982a5638069bbe89c869698dfea64b8`）は、貸出処理の一連の流れを示しています。

---

### 🇬🇧 English Analysis

#### ⚡ Synchronous Fast Path (Critical Path)

The **Borrow Service** processes the initial request in **543ms**, including:

- Input validation
- Membership verification
- Database transaction (persisting the borrow record)
- Event publication to Kafka

The user receives a success response immediately after this stage.

---

#### 🔄 Asynchronous Propagation (Event-Driven)

Once the `BorrowEvent` is published, downstream services consume it independently (**fan-out pattern**):

- **Inventory & Records Services**  
  → Update stock and user history (~140ms)

- **Analytics Service**  
  → Recomputes rankings asynchronously (~133ms)

- **Notification Service**  
  → Sends confirmation email (~264ms, heaviest task)

These operations are fully decoupled from the user request and do not impact perceived latency.

---

#### ⏳ Time to Eventual Consistency

The system reaches a fully consistent state in **~965ms**, without blocking the user interface.

---

### 🇯🇵 日本語による分析

#### ⚡ 同期的な高速パス（クリティカルパス）

Borrow Serviceはリクエストを**543ms**で処理し、以下を実行します：

- 入力バリデーション
- 会員ステータス確認
- データベースへのトランザクション保存
- Kafkaへのイベント発行

この段階でユーザーには即座に成功レスポンスが返されます。

---

#### 🔄 非同期伝播（イベント駆動）

`BorrowEvent`発行後、各サービスが独立してイベントを処理します（ファンアウトパターン）：

- **Inventory / Recordsサービス**  
  → 在庫と履歴を更新（約140ms）

- **Analyticsサービス**  
  → ランキングを非同期で再計算（約133ms）

- **Notificationサービス**  
  → メール通知を送信（約264ms・最も重い処理）

これらの処理はユーザーの体感レイテンシに影響しません。

---

#### ⏳ 結果整合性までの時間

システム全体は約**965ms**で整合性の取れた状態に到達します。ユーザー操作は一切ブロックされません。

---

### 💡 Engineering Insights / エンジニアリング考察

- The system follows a **"write fast, propagate later"** strategy  
  → 「即時書き込み・後続伝播」戦略を採用

- Heavy operations are isolated from the critical path  
  → 重い処理はクリティカルパスから分離

- Event-driven fan-out enables scalable and decoupled processing  
  → イベント駆動のファンアウトによりスケーラブルな処理を実現

- Asynchronous design guarantees responsiveness under load  
  → 非同期設計により高負荷でも応答性を維持

---

### 🚀 Summary

This project demonstrates a production-inspired distributed system with real-world architectural patterns such as CQRS,
event-driven design, and microservices.

本プロジェクトはCQRS、イベント駆動設計、マイクロサービスといった実務レベルのアーキテクチャを再現しています。
