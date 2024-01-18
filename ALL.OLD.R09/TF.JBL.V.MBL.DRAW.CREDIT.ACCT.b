SUBROUTINE TF.JBL.V.JBL.DRAW.CREDIT.ACCT
*-----------------------------------------------------------------------------
*Subroutine Description:    To update the Credit Account Field with the Corresponding Nostro Account
*                           of a specified Currency
*Subroutine Type:
*Attached To    : DRAWINGS Version (DRAWINGS,JBL.IMPDOCAMD.BKP)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 28/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING AC.AccountOpening
    
    $USING EB.ErrorProcessing
    $USING EB.DataAccess
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.NOSTRO = 'F.NOSTRO.ACCOUNT'
    F.NOSTRO = ''
    
    Y.CCY = EB.SystemTables.getComi()
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.NOSTRO,F.NOSTRO)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    EB.DataAccess.FRead(FN.NOSTRO,Y.CCY,R.NOSTRO.REC,F.NOSTRO,NOS.ERR)

    FIND 'LC' IN R.NOSTRO.REC<AC.AccountOpening.NostroAccount.EbNosApplication> SETTING Ap,Vp ELSE
        FIND 'TF' IN R.NOSTRO.REC<AC.AccountOpening.NostroAccount.EbNosApplication> SETTING Ap,Vp ELSE
           FIND 'ALL' IN R.NOSTRO.REC<AC.AccountOpening.NostroAccount.EbNosApplication> SETTING Ap,Vp ELSE
                EB.SystemTables.setE(" Nostro Account Missing for the Currency ")
                EB.ErrorProcessing.Err()
            END
        END
    END

    EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrPaymentAccount, R.NOSTRO.REC<EB.NOS.ACCOUNT,Vp>) 
RETURN
*** </region>
END
