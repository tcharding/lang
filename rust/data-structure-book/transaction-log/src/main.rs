use transaction_log::TransactionLog;

fn main() {
    let mut log = TransactionLog::new();
    log.append(String::from("first"));
    log.append(String::from("second"));

    println!("{:?}", log);
}
