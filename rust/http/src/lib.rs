use warp::Filter;

fn sum() -> impl Filter<Extract = (u32,), Error = warp::Rejection> + Copy {
    warp::path::param()
        .and(warp::path::param())
        .map(|x: u32, y: u32| {
            x + y
        })
}

fn math() -> impl Filter<Extract = (String,), Error = warp::Rejection> + Copy {
    warp::post2()
        .and(sum())
        .map(|z: u32| {
            format!("Sum = {}", z)
        })
}

#[test]
fn test_sum() {
    let filter = sum();

    // Execute `sum` and get the `Extract` back.
    let value = warp::test::request()
        .path("/1/2")
        .filter(&filter)
        .unwrap();
    assert_eq!(value, 3);

    // Or simply test if a request matches (doesn't reject).
    assert!(
        !warp::test::request()
            .path("/1/-5")
            .matches(&filter)
    );
}
