import java.io.*;
import com.notnoop.apns.*;

public class APNTest
{
	public static void main(String[] args)
	{
		ApnsService service =
			APNS.newService()
			.withCert(args[0], args[1])
			.withSandboxDestination()
			.build();
			
		String payload = APNS.newPayload().alertBody(args[3]).build();
		String token = args[2];
		service.push(token, payload);
	}
}