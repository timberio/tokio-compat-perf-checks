use futures01::{Future, Stream};
use tokio01::net::{TcpListener, TcpStream};
use tokio01::runtime::Runtime;
use tokio01::{io, spawn};

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let source_listener = TcpListener::bind(&common::socket_addr(common::SOURCE_ADDR))?;

    let mut rt = Runtime::new()?;
    rt.block_on(
        source_listener
            .incoming()
            .map_err(|e| println!("error = {:?}", e))
            .for_each(|source| {
                println!("start process {:?}", &source);
                spawn(
                    TcpStream::connect(&common::socket_addr(common::SINK_ADDR))
                        .and_then(|sink| io::copy(source, sink))
                        .map(|_| println!("end process"))
                        .map_err(|e| println!("error = {:?}", e)),
                );
                Ok(())
            }),
    )
    .unwrap();
    Ok(())
}
