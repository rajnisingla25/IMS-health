public class BBComm_Controller {
    public String decodedValue{get;set;}
    
    public BBComm_Controller()
    {
        
        decodedValue= ApexPages.currentPage().getParameters().get('sk');
        if(decodedValue!=null)
        {
            system.debug('Encoded String'+decodedValue);
            
            Blob b = EncodingUtil.base64Decode(decodedValue);
            
            decodedValue = b.toString();
            
        }
        
    }
}