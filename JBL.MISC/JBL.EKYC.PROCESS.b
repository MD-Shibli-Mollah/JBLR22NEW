SUBROUTINE JBL.EKYC.PROCESS(EKYC.ID)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.JBL.TP.INFO
    $INSERT I_F.EB.JBL.EKYC.INFO
    $INSERT I_F.JBL.EKYC.PROCESS.COMMON
    
    $USING EB.DataAccess
    $USING ST.Customer
    $USING EB.SystemTables
    $USING EB.Foundation
    $USING EB.Interface
    $USING AC.AccountOpening
    
    CRT 'PROCESSING WITH EKYC ID....... ': EKYC.ID
    
    EB.DataAccess.FRead(FN.EKYC, EKYC.ID, EKYC.REC, F.EKYC, ERR)
    CUS.AML.RES = EKYC.REC<EB.EKYC.CUS.AML.RESULT>
    CUS.ID      = EKYC.REC<EB.EKYC.CUS.ID>
    
    IF CUS.AML.RES EQ '' THEN
        IF CUS.ID EQ '' THEN
            OfsMessage<ST.Customer.Customer.EbCusNameOne>   = EKYC.REC<EB.EKYC.CUS.NAME>
            OfsMessage<ST.Customer.Customer.EbCusShortName> = EKYC.REC<EB.EKYC.CUS.SHORT.NAME>
            OfsMessage<ST.Customer.Customer.EbCusMnemonic>  = EKYC.REC<EB.EKYC.CUS.SHORT.NAME>[1, 1] : EKYC.ID[5, 14]
            OfsMessage<ST.Customer.Customer.EbCusSector>    = EKYC.REC<EB.EKYC.CUS.SECTOR>
            OfsMessage<ST.Customer.Customer.EbCusLanguage>  = EKYC.REC<EB.EKYC.CUS.LANGUAGE>
            
            TMP.VAR = 'MAIN.CUS'
            GOSUB OFS
            
            IF T24Status EQ '1' THEN
                EKYC.REC<EB.EKYC.CUS.ID>            = T24TxnRef
                EKYC.REC<EB.EKYC.CUS.AML.RESULT>    = 'WAITING'
                
            END
            ELSE ;* OFS ERROR
                EKYC.REC<EB.EKYC.CUS.ID>            = 'FAILED'
                EKYC.REC<EB.EKYC.CUS.AML.RESULT>    = 'PENDING'
                EKYC.REC<EB.EKYC.PROCESS.STATUS>    = 'FAILED'
            END
            WRITE EKYC.REC ON F.EKYC, EKYC.ID
            RETURN
        END
        ELSE ;* CUS.ID != ''
            GOSUB EKYC.PROCESS
        END
    END
    ELSE  ;* CUS.AML.RES = WAITING
        
        
        EB.DataAccess.FRead(FN.CUS.NAU, CUS.ID, CUS.REC, F.CUS.NAU, CUS.ERR)
        EB.Foundation.MapLocalFields('CUSTOMER', 'LT.CUS.AML', LT.CUS.AML.POS)
        CUS.AML.STATUS = CUS.REC<ST.Customer.Customer.EbCusLocalRef, LT.CUS.AML.POS>
        CUS.REC.STATUS = CUS.REC<ST.Customer.Customer.EbCusRecordStatus>
        
        IF CUS.AML.STATUS EQ 'NEGATIVE' THEN
            IF CUS.REC.STATUS EQ 'INAU' THEN
                
                TMP.VAR = 'CUS.AUTH'
                GOSUB OFS
                
                IF T24Status EQ '1' THEN
                    GOSUB EKYC.PROCESS
                END
                ELSE ;* AML NEGATIVE BUT AUTH FAILED
                    EKYC.REC<EB.EKYC.CUS.ID>            := '-AUTH.FAILED'
                    EKYC.REC<EB.EKYC.PROCESS.STATUS>    = 'FAILED'
                    WRITE EKYC.REC ON F.EKYC, EKYC.ID
                    RETURN
                END
            END
            ELSE IF  CUS.REC.STATUS EQ '' THEN ;* EKYC CUSTOMER ALREADY IN LIVE
                GOSUB EKYC.PROCESS
            END
        END
        ELSE IF CUS.AML.STATUS EQ 'POSITIVE' THEN    ;*  AML POSITIVE
            EKYC.REC<EB.EKYC.PROCESS.STATUS> = 'FAILED'
            EKYC.REC<EB.EKYC.CUS.AML.RESULT> = 'POSITIVE'
            WRITE EKYC.REC ON F.EKYC, EKYC.ID
            RETURN
        END
        ELSE
            RETURN
        END
    END
    
RETURN
***************************************************************************************************************************************
   
EKYC.PROCESS:
    
    NOM.ALL.CUS.ID = EKYC.REC<EB.EKYC.NOM.ID>
    CONVERT VM TO FM IN NOM.ALL.CUS.ID
    CRT NOM.ALL.CUS.ID
    CNT = DCOUNT(NOM.ALL.CUS.ID, @FM)
    CRT CNT
*FOR I = 1 TO DCOUNT(EKYC.REC<EB.EKYC.NOM.NAME>, @VM)
    FOR I = 1 TO DCOUNT(NOM.ALL.CUS.ID, @FM)
        NOM.CUS.ID = NOM.ALL.CUS.ID<I>
        CRT NOM.CUS.ID
        
        IF NOM.CUS.ID EQ '' THEN ;* NOMINEE ID NOT EXIST
            OfsMessage<ST.Customer.Customer.EbCusNameOne>   = EKYC.REC<EB.EKYC.NOM.NAME, I>
            OfsMessage<ST.Customer.Customer.EbCusShortName> = EKYC.REC<EB.EKYC.NOM.NAME, I>
            
            IF T24TxnRef EQ '' THEN
                OfsMessage<ST.Customer.Customer.EbCusMnemonic>  = EKYC.REC<EB.EKYC.NOM.NAME>[1, 1] : CUS.ID
            END ELSE
                OfsMessage<ST.Customer.Customer.EbCusMnemonic>  = EKYC.REC<EB.EKYC.NOM.NAME>[1, 1] : T24TxnRef
            END
        
            OfsMessage<ST.Customer.Customer.EbCusLanguage>  = EKYC.REC<EB.EKYC.CUS.LANGUAGE>
            OfsMessage<ST.Customer.Customer.EbCusSector>    = EKYC.REC<EB.EKYC.CUS.SECTOR>
            
            TMP.VAR = 'NOM.CUS'
            GOSUB OFS
            
            IF T24Status EQ '1' THEN
                EKYC.REC<EB.EKYC.NOM.ID, I> = T24TxnRef
            END
            ELSE    ;* OFS FAILED
                EKYC.REC<EB.EKYC.NOM.ID, I>         = 'FAILED'
                EKYC.REC<EB.EKYC.PROCESS.STATUS>    = 'FAILED'
                NOM.STATUS                          = 'FAILED'
            END
        END
        
    NEXT I
    
    IF NOM.STATUS NE 'FAILED' THEN  ;* ALL NOMINEE CREATION SUCCESS
        
        OfsMessage<AC.AccountOpening.Account.Customer> = EKYC.REC<EB.EKYC.CUS.ID>
        OfsMessage<AC.AccountOpening.Account.Category> = EKYC.REC<EB.EKYC.AC.CATEGORY>
        OfsMessage<AC.AccountOpening.Account.Currency> = EKYC.REC<EB.EKYC.AC.CURRENCY>
        
        TMP.VAR = 'AC'
        GOSUB OFS
        
        IF T24Status EQ '1' THEN
            EKYC.REC<EB.EKYC.AC.ID> = T24TxnRef
            AC.STATUS               = 'OK'
        END
        ELSE ;* OFS FAILED
            EKYC.REC<EB.EKYC.AC.ID>             = 'FAILED'
            EKYC.REC<EB.EKYC.PROCESS.STATUS>    = 'FAILED'
            AC.STATUS                           = 'FAILED'
        END
    END
    ELSE    ;* ALL NOMINEE CREATION NOT SUCCESS
        WRITE EKYC.REC ON F.EKYC, EKYC.ID
        RETURN
    END
    
    IF AC.STATUS EQ 'OK' THEN   ;* ACCOUNT CREATION SUCCESS
        OfsMessage<EB.JBL91.MAX.PER.TXN.AMT>    = EKYC.REC<EB.EKYC.TP.MAX.PER.TXN.AMT>
        OfsMessage<EB.JBL91.NO.OF.TXN>          = EKYC.REC<EB.EKYC.TP.NO.OF.TXN>
        OfsMessage<EB.JBL91.TOTAL.AMOUNT>       = EKYC.REC<EB.EKYC.TP.TOTAL.AMOUNT>
        
        TMP.VAR = 'TP'
        GOSUB OFS
        
        IF T24Status EQ '1' THEN
            EKYC.REC<EB.EKYC.TP.ID> = T24TxnRef
            EKYC.REC<EB.EKYC.CUS.AML.RESULT> = 'NEGATIVE'
            EKYC.REC<EB.EKYC.PROCESS.STATUS> = 'PROCESSED'
        END
        ELSE    ;* OFS FAILED
            EKYC.REC<EB.EKYC.TP.ID>             = 'FAILED'
            EKYC.REC<EB.EKYC.CUS.AML.RESULT>    = 'PENDING'
            EKYC.REC<EB.EKYC.PROCESS.STATUS>    = 'FAILED'
        END
    END
    
    WRITE EKYC.REC ON F.EKYC, EKYC.ID
    
RETURN

OFS:
    
    Ofsrecord = ''; T24TxnRef = ''; T24Status = ''

    IF TMP.VAR EQ 'MAIN.CUS' THEN
        EB.Foundation.OfsBuildRecord('CUSTOMER', 'I', 'PROCESS', 'CUSTOMER,EKYC.OFS', '', 1, '', OfsMessage, Ofsrecord)
    END
    ELSE IF TMP.VAR EQ 'CUS.AUTH' THEN
        EB.Foundation.OfsBuildRecord('CUSTOMER', 'A', 'PROCESS', 'CUSTOMER,EKYC.AUTH', '', 0, CUS.ID, '', Ofsrecord)
    END
    ELSE IF TMP.VAR EQ 'NOM.CUS' THEN
        EB.Foundation.OfsBuildRecord('CUSTOMER', 'I', 'PROCESS', 'CUSTOMER,EKYC.NOM', '', 0, '', OfsMessage, Ofsrecord)
    END
    ELSE IF TMP.VAR EQ 'AC' THEN
        EB.Foundation.OfsBuildRecord('ACCOUNT', 'I', 'PROCESS', 'ACCOUNT,EKYC.OFS', '', 0, '', OfsMessage, Ofsrecord)
    END
    ELSE IF TMP.VAR EQ 'TP' THEN
        EB.Foundation.OfsBuildRecord('EB.JBL.TP.INFO', 'I', 'PROCESS', 'EB.JBL.TP.INFO,EKYC.OFS', '', 0, '', OfsMessage, Ofsrecord)
    END
    ELSE
        RETURN
    END
    
    EB.Interface.OfsGlobusManager('EKYC', Ofsrecord)
    T24TxnRef = FIELD(Ofsrecord, '/', 1);
    T24Status = FIELD(FIELD(Ofsrecord, '/', 3), ',', 1);
    OfsMessage = ''
    
    CRT Ofsrecord
    CRT T24Status
    CRT T24TxnRef
RETURN

