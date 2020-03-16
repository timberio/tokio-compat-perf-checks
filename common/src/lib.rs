pub const SOURCE_ADDR: &'static str = "127.0.0.1:1521";
pub const SINK_ADDR: &'static str = "127.0.0.1:1522";

pub fn socket_addr(s: &'static str) -> std::net::SocketAddr {
    s.parse().unwrap()
}
