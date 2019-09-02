use transaction_log::TransactionLog;

fn main() {
    println!("Transaction log, linked list example");

    let mut log = TransactionLog::new();
    log.append(String::from("first log entry"));

    println!("{:?}", log);
}
