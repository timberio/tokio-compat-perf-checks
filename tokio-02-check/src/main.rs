use tokio02::net::{TcpListener, TcpStream};
use tokio02::runtime::Runtime;
use tokio02::spawn;
use tokio02::io::copy;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut rt = Runtime::new()?;
    rt.block_on(async {
        let mut source_listener = TcpListener::bind(common::socket_addr(common::SOURCE_ADDR)).await?;
        loop {
            let (mut source, _) = source_listener.accept().await?;
            spawn(async move {
                let mut sink = TcpStream::connect(common::socket_addr(common::SINK_ADDR)).await?;
                copy(&mut source, &mut sink).await
            });
        }
    })
}
