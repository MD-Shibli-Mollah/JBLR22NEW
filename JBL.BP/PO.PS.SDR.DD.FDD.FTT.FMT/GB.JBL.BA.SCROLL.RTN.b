
SUBROUTINE GB.JBL.BA.SCROLL.RTN
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*Subroutine Description:
* THIS ROUTINE IS USED to update SCROLL for DD/TT/MT in EB.JBL.H.SCROLL
*
*Attached To    : VERSION(TELLER,JBL.INSTR.LCY.CASHIN.TT.MT, FUNDS.TRANSFER,JBL.DD.ISSUE.2)
*Attached As    : BEFORE AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 11/06/2024 - CREATED BY                         NEW - MD Shibli Mollah
*                                                 NITSL

* LT.BRANCH is used for storing Other Branch Information
*-----------------------------------------------------------------------------

    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.EB.JBL.H.SCROLL
    $USING   FT.Contract
    $USING   TT.Contract
    $USING   EB.SystemTables
    $USING   EB.DataAccess
    $USING   EB.Updates

    IF EB.SystemTables.getVFunction() EQ "R" OR EB.SystemTables.getRNew(FT.Contract.FundsTransfer.RecordStatus) EQ "RNAU" OR EB.SystemTables.getRNew(TT.Contract.Teller.TeRecordStatus) EQ "RNAU" THEN RETURN

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*----
INIT:
*----
    FN.SCROLL = "F.EB.JBL.H.SCROLL"
    F.SCROLL = ""

    Y.APP.NAME = "FUNDS.TRANSFER" : @FM : "TELLER"
    Y.LOCAL.FIELDS = "LT.SCROLL": @VM : "LT.BRANCH": @VM : "LT.DD.TT.MT": @VM : "LT.ISS.OLD.CHQ": @FM: "LT.SCROLL": @VM : "LT.BRANCH": @VM : "LT.DD.TT.MT"
    EB.Updates.MultiGetLocRef(Y.APP.NAME, Y.LOCAL.FIELDS, Y.FIELDS.POS)
   
    Y.SCROLL.POS.FT = Y.FIELDS.POS<1,1>
    Y.COMP.POS.FT = Y.FIELDS.POS<1,2>
    Y.TTMT.POS.FT = Y.FIELDS.POS<1,3>
    Y.LT.ISS.OLD.CHQ.POS = Y.FIELDS.POS<1,4>
    
    Y.SCROLL.POS.TT = Y.FIELDS.POS<2,1>
    Y.COMP.POS.TT = Y.FIELDS.POS<2,2>
    Y.TTMT.POS.TT = Y.FIELDS.POS<2,3>
    
    
RETURN

*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.SCROLL, F.SCROLL)
RETURN

*-------
PROCESS:
*-------
    Y.COMPANY = EB.SystemTables.getIdCompany()
    Y.TODAY = EB.SystemTables.getToday()
    Y.APP = EB.SystemTables.getApplication()
    
    Y.SCROLL.DD.NO = 0
    Y.SCROLL.TT.NO = 0
    Y.SCROLL.MT.NO = 0
    
    
    IF Y.APP EQ "TELLER" THEN
        Y.CHEQUE.TYPE = EB.SystemTables.getRNew(TT.Contract.Teller.TeIssueChequeType)
        Y.LT.TT = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
        
        BEGIN CASE
            
            CASE Y.CHEQUE.TYPE EQ "DD"
                Y.SCROLL.ID = RIGHT(Y.COMPANY,4):".":RIGHT(Y.LT.TT<1,Y.COMP.POS.TT>,4):".":Y.TODAY[1,4]
                
                EB.DataAccess.FRead(FN.SCROLL, Y.SCROLL.ID, REC.SCROLL, F.SCROLL, ERR.SCROLL)
                IF REC.SCROLL THEN
                    Y.SCROLL.DD.NO = REC.SCROLL<EB.JBL57.DD.SCROLL.NO> + 1
                    REC.SCROLL<EB.JBL57.DD.SCROLL.NO> = Y.SCROLL.DD.NO
                    Y.LT.TT<1,Y.SCROLL.POS.TT> = Y.SCROLL.DD.NO
                    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.LT.TT)
                END
            
                ELSE
                    REC.SCROLL<EB.JBL57.DD.SCROLL.NO> = 1
                    Y.LT.TT<1,Y.SCROLL.POS.TT> = 1
                    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.LT.TT)
                END
                WRITE REC.SCROLL ON F.SCROLL,Y.SCROLL.ID

            CASE Y.CHEQUE.TYPE EQ "TT"
                Y.SCROLL.ID = RIGHT(Y.COMPANY,4):".":RIGHT(Y.LT.TT<1,Y.COMP.POS.TT>,4):".":Y.TODAY[1,4]
                
                EB.DataAccess.FRead(FN.SCROLL, Y.SCROLL.ID, REC.SCROLL, F.SCROLL, ERR.SCROLL)
                IF REC.SCROLL THEN
                    Y.SCROLL.TT.NO = REC.SCROLL<EB.JBL57.TT.SCROLL.NO> + 1
                    REC.SCROLL<EB.JBL57.TT.SCROLL.NO> = Y.SCROLL.TT.NO
                    Y.LT.TT<1,Y.SCROLL.POS.TT> = Y.SCROLL.TT.NO
                    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.LT.TT)
                END
                ELSE
                    REC.SCROLL<EB.JBL57.TT.SCROLL.NO> = 1
                    Y.LT.TT<1,Y.SCROLL.POS.TT> = 1
                    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.LT.TT)
                END

                WRITE REC.SCROLL ON F.SCROLL,Y.SCROLL.ID

            CASE Y.CHEQUE.TYPE EQ "MT"
                Y.SCROLL.ID = RIGHT(Y.COMPANY,4):".":RIGHT(Y.LT.TT<1,Y.COMP.POS.TT>,4):".":Y.TODAY[1,4]
                
                EB.DataAccess.FRead(FN.SCROLL, Y.SCROLL.ID, REC.SCROLL, F.SCROLL, ERR.SCROLL)
                IF REC.SCROLL THEN
                    Y.SCROLL.MT.NO = REC.SCROLL<EB.JBL57.MT.SCROLL.NO> + 1
                    REC.SCROLL<EB.JBL57.MT.SCROLL.NO> = Y.SCROLL.MT.NO
                    Y.LT.TT<1,Y.SCROLL.POS.TT> = Y.SCROLL.MT.NO
                    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.LT.TT)
                END
                ELSE
                    REC.SCROLL<EB.JBL57.MT.SCROLL.NO> = 1
                    Y.LT.TT = Y.LT.TT
                    Y.LT.TT<1,Y.SCROLL.POS.TT> = 1
                    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.LT.TT)
                END
                WRITE REC.SCROLL ON F.SCROLL,Y.SCROLL.ID

        END CASE
    END

    IF Y.APP EQ "FUNDS.TRANSFER" THEN
        Y.CHEQUE.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.IssueChequeType)
        Y.LT.FT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
        
        IF Y.CHEQUE.TYPE EQ "" THEN
            Y.LT.ISS.OLD.CHQ = Y.LT.FT<1,Y.LT.ISS.OLD.CHQ.POS>
            Y.CHEQUE.TYPE = Y.LT.ISS.OLD.CHQ
        END
        
        BEGIN CASE
            CASE Y.CHEQUE.TYPE EQ "DD"
                Y.SCROLL.ID = RIGHT(Y.COMPANY,4):".":RIGHT(Y.LT.FT<1,Y.COMP.POS.FT>,4):".":Y.TODAY[1,4]
                
                EB.DataAccess.FRead(FN.SCROLL, Y.SCROLL.ID, REC.SCROLL, F.SCROLL, ERR.SCROLL)
                IF REC.SCROLL THEN
                    Y.SCROLL.DD.NO = REC.SCROLL<EB.JBL57.DD.SCROLL.NO> + 1
                    REC.SCROLL<EB.JBL57.DD.SCROLL.NO> = Y.SCROLL.DD.NO
                    Y.LT.FT<1,Y.SCROLL.POS.FT> = Y.SCROLL.DD.NO
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LT.FT)
                END
                ELSE
                    REC.SCROLL<EB.JBL57.DD.SCROLL.NO> = 1
                    Y.LT.FT<1,Y.SCROLL.POS.FT> = 1
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LT.FT)
                END
                WRITE REC.SCROLL ON F.SCROLL,Y.SCROLL.ID

            CASE Y.CHEQUE.TYPE EQ "TT"
                Y.SCROLL.ID = RIGHT(Y.COMPANY,4):".":RIGHT(Y.LT.FT<1,Y.COMP.POS.FT>,4):".":Y.TODAY[1,4]
                
                EB.DataAccess.FRead(FN.SCROLL,Y.SCROLL.ID,REC.SCROLL,F.SCROLL,ERR.SCROLL)
                IF REC.SCROLL THEN
                    Y.SCROLL.TT.NO = REC.SCROLL<EB.JBL57.TT.SCROLL.NO> + 1
                    REC.SCROLL<EB.JBL57.TT.SCROLL.NO> = Y.SCROLL.TT.NO
                    Y.LT.FT<1,Y.SCROLL.POS.FT> = Y.SCROLL.TT.NO
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LT.FT)
                END
                ELSE
                    Y.LT.FT<1,Y.SCROLL.POS.FT> = 1
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LT.FT)
                    REC.SCROLL<EB.JBL57.TT.SCROLL.NO> = 1
                END
                WRITE REC.SCROLL ON F.SCROLL,Y.SCROLL.ID
              
            CASE Y.CHEQUE.TYPE EQ "MT"
                Y.SCROLL.ID = RIGHT(Y.COMPANY,4):".":RIGHT(Y.LT.FT<1,Y.COMP.POS.FT>,4):".":Y.TODAY[1,4]
                
                EB.DataAccess.FRead(FN.SCROLL,Y.SCROLL.ID,REC.SCROLL,F.SCROLL,ERR.SCROLL)
                IF REC.SCROLL THEN
                    Y.SCROLL.MT.NO = REC.SCROLL<EB.JBL57.MT.SCROLL.NO> + 1
                    REC.SCROLL<EB.JBL57.MT.SCROLL.NO> = Y.SCROLL.MT.NO
                    Y.LT.FT<1,Y.SCROLL.POS.FT> = Y.SCROLL.MT.NO
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LT.FT)
                    
                END
                ELSE
                    REC.SCROLL<EB.JBL57.MT.SCROLL.NO> = 1
                    Y.LT.FT<1,Y.SCROLL.POS.FT> = 1
                    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LT.FT)
                END
                WRITE REC.SCROLL ON F.SCROLL,Y.SCROLL.ID
             
        END CASE
    END
        
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "Y.SCROLL.ID: ": Y.SCROLL.ID
    FileName = "SHIBLI_SCROLL.txt"
    FilePath = "DL.BP"
*   FilePath = "D:\Temenos\t24home\default\SHIBLI.BP"
    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
    ELSE
        CREATE FileOutput ELSE
        END
    END
    WRITESEQ WriteData APPEND TO FileOutput ELSE
        CLOSESEQ FileOutput
    END
    CLOSESEQ FileOutput
*******--------------------------TRACER-END--------------------------------------------------------*********************
     
RETURN
END

